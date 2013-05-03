class ApiPagesController < ApiController
  respond_to :json
  
  # POST /api/pages
  def create
    raise "Token missing." if params[:token].blank?
    params[:pages].each do |url, data|
      viewed = data["viewed"].to_i
      page = Page.find_by_url(url)
      page = Page.create(url: url, title: data["title"]) unless page
      
      user_page = UserPage.find_by_page_id_and_user_id(page.id, params[:token])  
      if user_page
        if viewed > user_page.viewed and viewed < 300
          user_page.update_attribute(:viewed, viewed)
        end
      else
        user_page = UserPage.create!(page_id: page.id, user_id: params[:token], viewed: viewed)
      end
    end
    render json: { status: :created }
  end
end