class PagesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :check_token
  
  # GET /pages
  # GET /pages.json
  def index
    all_pages = Page.joins(:user_pages).select("pages.*, user_pages.updated_at, user_pages.viewed").where("user_pages.user_id = ?", user_session[:token])
    @top_pages = all_pages.where("viewed > ?", 10).order("id DESC").limit(50)
    @bottom_pages = all_pages.where("viewed < ?", 10).order("id DESC").limit(50)

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
        .where("user_pages.user_id = ?", user_session[:token])
        .where("title ILIKE ?", "%#{query}%")
        .collect { |i| { title: i.title, url: i.url, updated_at: i.updated_at, viewed: i.viewed } }
    end
    render json: items
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
