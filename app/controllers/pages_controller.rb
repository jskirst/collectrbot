class PagesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :check_token
  
  # GET /pages
  # GET /pages.json
  def index
    @viewing = params[:v] || "top"
    all_pages = Page.joins(:user_pages).select("pages.*, user_pages.updated_at, user_pages.viewed").where("user_pages.user_id = ?", user_token)
    if @viewing == "top"
      pages = all_pages.where("viewed > ?", 10).order("id DESC").limit(50)
    else
      pages = all_pages.order("id DESC").limit(200)
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
  
  # PUT /pages/1/archive
  def archive
    up = UserPage.find_by_user_id_and_page_id(user_token, params[:id])
    up.update_attribute(:archived, true)
    render json: { success: true }
  end
  
  # PUT /pages/1/share
  def share
    up = UserPage.find_by_user_id_and_page_id(user_token, params[:id])
    up.update_attribute(:favoritied, true)
    render json: { success: true }
  end
  
  # DELETE /pages/1
  def destroy
    up = UserPage.find_by_user_id_and_page_id(user_token, params[:id])
    up.destroy
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
