class ApiPagesController < ApiController
  before_filter :authenticate_with_token
 
  respond_to :json
  
  # POST /api/pages
  def create
    updated_pages = []
    created_pages = []
    page_errors = []
    
    params[:pages].each do |url, page|
      viewed = page["viewed"].to_i
      title = page["title"]
      existing_page = @user.pages.find_by_url(url)
      if existing_page
        if viewed > existing_page.viewed and viewed < 300
          if existing_page.update_attribute(:viewed, viewed)
            updated_pages << existing_page
          else
            raise existing_page.to_yaml
          end
        end
      else
        new_page = @user.pages.new(url: url, viewed: viewed, title: title)
        if new_page.save!
          created_pages << new_page
        else
          raise new_page.to_yaml
        end
      end
    end

    render json: { updated_pages: updated_pages, created_pages: created_pages, page_errors: page_errors, status: :created }
  end
  
  protected
  def authenticate_with_token
    unless @user = User.find_by_authentication_token(params[:auth_token])
      render json: { success: false, message: "Error with your login or password" }, status: 401
      return
    end
  end
end