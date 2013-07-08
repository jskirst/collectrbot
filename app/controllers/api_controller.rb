class ApiController < ApplicationController
  skip_before_filter :verify_authenticity_token
  before_filter :ensure_login_params_exist
  
  respond_to :json
  
  private
  def ensure_login_params_exist
    return unless params[:email].blank? or params[:password].blank?
    render json: { success: :failure, message: "missing login parameters" }
  end
  
  def authenticate
    user = User.find_for_database_authentication(email: params[:email])
    return invalid_login_attempt unless user
 
    if user.valid_password?(params[:password])
      @current_user = user
    else
      return false
    end
  end
  
  def invalid_login_attempt
    warden.custom_failure!
    render json: { success: :failure, message: "Error with your login or password" }
  end
end
