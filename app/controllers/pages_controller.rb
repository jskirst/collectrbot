class PagesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :check_token
  before_filter :load_resource, only: [:trash, :archive, :favorite, :share]
  
  # GET /pages
  # GET /pages.json
  def index
    @viewing = params[:v] || "new"
    all_pages = UserPage.joins("LEFT JOIN pages on pages.id = user_pages.page_id")
      .select("user_pages.*, pages.title, pages.url, pages.id as page_id")
      .where("user_pages.user_id = ? or user_pages.user_id = ?", user_token, current_user.id.to_s)
    if @viewing == "new"
      pages = all_pages.where("trashed is ? and shared is ? and favorited is ? and archived is ?", nil, nil, nil, nil)
        .order("user_pages.viewed DESC").limit(1000)
    elsif @viewing == "shared"
      pages = all_pages.where("shared is not ?", nil)
        .order("user_pages.id DESC").limit(1000)
    elsif @viewing == "favorites"
      pages = all_pages.where("favorited is not ?", nil)
        .order("user_pages.id DESC").limit(1000)
    elsif @viewing == "archived"
      pages = all_pages.where("archived is not ?", nil)
        .order("user_pages.id DESC").limit(1000)
    elsif @viewing == "trash"
      pages = all_pages.where("trashed is not ?", nil)
        .order("user_pages.id DESC").limit(1000)
    end
    
    @pages = unflatten(pages.to_a, :domain)
    @left_panel = :feeds
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @pages }
    end
  end
  
  # GET /pages/find
  def find
    query = params[:term]
    if query.blank?
      items = []
    else
      items = Page.joins(:user_pages)
        .select("pages.*, user_pages.updated_at, user_pages.viewed")
        .where("user_pages.user_id = ? or user_pages.user_id = ?", user_token, current_user.id.to_s)
        .where("title ILIKE ?", "%#{query}%")
        .collect { |i| { title: i.title, url: i.url, updated_at: i.updated_at, viewed: i.viewed } }
    end
    render json: items
  end
  
  # PUT /pages/1/trash
  # POST /pages/trash
  def trash
    if request.put?
      @up.update_attributes!(trashed: Time.now(), archived: nil, favorited: nil, shared: nil, user_id: user_token)
    else
      @ups.update_all(trashed: Time.now(), archived: nil, favorited: nil, shared: nil, user_id: user_token)
    end
    
    if request.xhr?
      render json: { success: true }
    else
      redirect_to root_url, success: "Trashed."
    end
  end
  
  # PUT /pages/1/archive
  # POST /pages/archive
  def archive
    if request.put?
      @up.update_attributes!(archived: Time.now(), trashed: nil, favorited: nil, shared: nil, user_id: user_token)
    else
      @ups.update_all(archived: Time.now(), trashed: nil, favorited: nil, shared: nil, user_id: user_token)
    end
    
    if request.xhr?
      render json: { success: true }
    else
      redirect_to root_url, success: "Archived."
    end
  end
  
  # PUT /pages/1/favorite
  def favorite
    @up.update_attributes!(favorited: Time.now(), archived: nil, trashed: nil, shared: nil, user_id: user_token)
    render json: { success: true }
  end
  
  # PUT /pages/1/share
  def share
    @up.update_attributes!(shared: Time.now(), archived: nil, trashed: nil, favorited: nil, user_id: current_user.id.to_s)
    render json: { success: true }
  end
  
  def empty
    UserPage.where("user_id = ? and trashed is not ?", user_token, nil).destroy_all
    redirect_to root_url
  end
  
  private
  
  def check_token
    redirect_to new_user_session_path if user_session[:token].blank?
  end
  
  def load_resource
    if request.put?
      @up = UserPage.where("(user_id = ? or user_id = ?) and page_id = ?", user_token, current_user.id.to_s, params[:id]).first
    elsif request.post?
      @ups = UserPage.where("user_id = ? or user_id = ?", user_token, current_user.id.to_s)
      if params[:ids] == "all"
        @ups = @ups.where("trashed is ? and archived is ? and shared is ? and favorited is ?", nil, nil, nil, nil)
      else
        @ups = @ups.where("page_id in (?)", params[:ids])
      end
    end
  end
end
