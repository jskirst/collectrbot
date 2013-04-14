class PagesController < ApplicationController
  skip_before_filter :verify_authenticity_token, only: [:create]
  before_filter :authenticate_user!, except: [:create]
  
  # GET /pages
  # GET /pages.json
  def index
    @top_pages = Page.where("viewed > ?", 10).order("id DESC").limit(50)
    @bottom_pages = Page.where("viewed < ?", 10).order("id DESC").limit(50)

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
      items = Page.where("title like ?", "%#{query}%").collect { |i| { title: i.title, url: i.url, updated_at: "20 minutes ago" } }
    end
    
    render json: items
  end

  # GET /pages/1
  # GET /pages/1.json
  def show
    @page = Page.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @page }
    end
  end

  # GET /pages/new
  # GET /pages/new.json
  def new
    @page = Page.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @page }
    end
  end

  # GET /pages/1/edit
  def edit
    @page = Page.find(params[:id])
  end

  # POST /pages
  # POST /pages.json
  def create
    unless user = User.find_by_authentication_token(params[:auth_token])
      render json: { success: false, message: "Error with your login or password" }, status: 401
      return
    end
    
    updated_pages = []
    created_pages = []
    page_errors = []
    params[:pages].each do |url, page_details|
      page = page_details["page"]
      viewed = page_details["viewed"].to_i
      existing_page = user.pages.find_by_url(page["url"])
      if existing_page
        if viewed > existing_page.viewed and viewed < 300
          if existing_page.update_attribute(:viewed, viewed)
            updated_pages << existing_page
          else
            #raise existing_page.to_yaml
          end
        end
      else
        new_page = user.pages.new(page.merge(viewed: viewed))
        if new_page.save!
          created_pages << new_page
        else
          #raise new_page.to_yaml
        end
      end
    end

    render json: { updated_pages: updated_pages, created_pages: created_pages, page_errors: page_errors, status: :created }
  end

  # PUT /pages/1
  # PUT /pages/1.json
  def update
    @page = Page.find(params[:id])

    respond_to do |format|
      if @page.update_attributes(params[:page])
        format.html { redirect_to @page, notice: 'Page was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @page.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pages/1
  # DELETE /pages/1.json
  def destroy
    @page = Page.find(params[:id])
    @page.destroy

    respond_to do |format|
      format.html { redirect_to pages_url }
      format.json { head :no_content }
    end
  end
end
