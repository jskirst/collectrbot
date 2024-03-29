class ApiPagesController < ApiController
  before_filter :authenticate
  
  # POST /api/pages
  def create
    encrypted_id = current_user.encrypted_id(params[:password])
    params[:pages].each do |url, data|
      viewed = data["viewed"].to_i
      page = Page.find_by_url(url)
      page = Page.create(url: url, title: data["title"]) unless page
      
      user_page = UserPage.where("page_id = ? and (user_id = ? or user_id = ?)", page.id, encrypted_id, current_user.id.to_s).first  
      if user_page
        if viewed > user_page.viewed and viewed < 300
          user_page.update_attribute(:viewed, viewed)
        end
      else
        user_page = UserPage.create!(page_id: page.id, user_id: encrypted_id, viewed: viewed)
      end
    end
    render json: { status: :created }
  end
end