class PagesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :check_token
  
  # GET /pages
  # GET /pages.json
  def index
    @viewing = params[:v] || "new"
    all_pages = UserPage.joins("LEFT JOIN pages on pages.id = user_pages.page_id")
      .select("user_pages.*, pages.title, pages.url, pages.id as page_id")
      .where("user_pages.user_id = ? or user_pages.user_id = ?", user_token, current_user.id.to_s)
    if @viewing == "newest"
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
        .where("user_pages.user_id = ?", user_token)
        .where("title ILIKE ?", "%#{query}%")
        .collect { |i| { title: i.title, url: i.url, updated_at: i.updated_at, viewed: i.viewed } }
    end
    render json: items
  end
  
  # PUT /pages/1/trash
  def trash
    if request.put?
      up = UserPage.find_by_user_id_and_page_id(user_token, params[:id])
      up.update_attributes!(trashed: Time.now(), archived: nil, favorited: nil, shared: nil, user_id: user_token)
    else
      ups = UserPage.where("page_id in (?) and user_id = ?", params[:ids], user_token)
      ups.update_all(trashed: Time.now(), archived: nil, favorited: nil, shared: nil, user_id: user_token)
    end
    render json: { success: true }
  end
  
  # PUT /pages/1/archive
  def archive
    if request.put?
      up = UserPage.find_by_user_id_and_page_id(user_token, params[:id])
      up.update_attributes!(archived: Time.now(), trashed: nil, favorited: nil, shared: nil, user_id: user_token)
    else
      ups = UserPage.where("page_id in (?) and user_id = ?", params[:ids], user_token)
      ups.update_all(archived: Time.now(), trashed: nil, favorited: nil, shared: nil, user_id: user_token)
    end
    render json: { success: true }
  end
  
  # PUT /pages/1/favorite
  def favorite
    up = UserPage.find_by_user_id_and_page_id(user_token, params[:id])
    up.update_attributes!(favorited: Time.now(), archived: nil, trashed: nil, shared: nil, user_id: user_token)
    render json: { success: true }
  end
  
  # PUT /pages/1/share
  def share
    up = UserPage.find_by_user_id_and_page_id(user_token, params[:id])
    up.update_attributes!(shared: Time.now(), archived: nil, trashed: nil, favorited: nil, user_id: current_user.id.to_s)
    render json: { success: true }
  end

  # # GET /pages/1
  # # GET /pages/1.json
  # def show
  #   @page = Page.find(params[:id])
  # 
  #   respond_to do |format|
  #     format.html # show.html.erb
  #     format.json { render json: @page }
  #   end
  # end
  # 
  # # PUT /pages/1
  # # PUT /pages/1.json
  # def update
  #   @page = Page.find(params[:id])
  # 
  #   respond_to do |format|
  #     if @page.update_attributes(params[:page])
  #       format.html { redirect_to @page, notice: 'Page was successfully updated.' }
  #       format.json { head :no_content }
  #     else
  #       format.html { render action: "edit" }
  #       format.json { render json: @page.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end
  # 
  # # DELETE /pages/1
  # # DELETE /pages/1.json
  # def destroy
  #   @page = Page.find(params[:id])
  #   @page.destroy
  # 
  #   respond_to do |format|
  #     format.html { redirect_to pages_url }
  #     format.json { head :no_content }
  #   end
  # end
end
