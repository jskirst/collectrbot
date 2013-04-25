class ApplicationController < ActionController::Base
  protect_from_forgery
  
  private
  def check_token
    raise "Missing token" if user_session[:token].blank?
  end
end
