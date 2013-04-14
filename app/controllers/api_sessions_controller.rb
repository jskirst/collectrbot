class ApiSessionsController < ApplicationController
  before_filter :ensure_params_exist
 
  respond_to :json
  
  def create
    user = User.find_for_database_authentication(email: params[:email])
    return invalid_login_attempt unless user
 
    if user.valid_password?(params[:password])
      sign_in(user)
      render json: { success: true, token: user.authentication_token, email: user.email }
      return
    end
    invalid_login_attempt
  end
  
  protected
  def ensure_params_exist
    return unless params[:email].blank? or params[:password].blank?
    render json: { success: false, message: "missing login parameters" }, status: 422
  end
 
  def invalid_login_attempt
    warden.custom_failure!
    render json: { success: false, message: "Error with your login or password" }, status: 401
  end
end
  