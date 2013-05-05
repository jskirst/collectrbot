class UsersController < ApplicationController
  before_filter :authenticate_user!
  
  # GET /users/1
  def show
    @user = User.find_by_username(params[:id])
    pages = UserPage.joins("LEFT JOIN pages on pages.id = user_pages.page_id")
      .select("user_pages.*, pages.title, pages.url, pages.id as page_id")
      .where("user_pages.user_id = ?", @user.id.to_s)
      .where("shared is not ?", nil)
      .order("user_pages.id DESC")
      .limit(1000)
      .to_a
    @pages = unflatten(pages, "domain")
  end

  # GET /users/1/edit  
  def edit
    @viewing = params[:v] || "username"
    if @viewing == "delete"
      render "delete"
    end
  end
  
  # PUT /users/1
  def update
    if params[:user][:current_password].blank?
      flash[:error] = "You must verify current password to save changes."
    else
      current_user.update_attributes(params[:user])
    end
    redirect_to edit_user_path(current_user), success: "Update successful."
  end
  
  def destroy
    current_user.wipe_clean
    current_user.destroy
    redirect_to root_url
  end
  
  def subscribe
    followed_user = User.find(params[:id])
    current_user.follow!(followed_user)
    redirect_to followed_user
  end
  
  def unsubscribe
    followed_user = User.find(params[:id])
    current_user.unfollow!(followed_user)
  end
  
  def approve
    current_user.approve_subscriber!(User.find(params[:id]))
  end
end