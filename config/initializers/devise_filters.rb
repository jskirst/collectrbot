# From: http://scottwb.com/blog/2012/02/16/revisited-adding-filters-to-stock-devise-controllers/
module DeviseFilters
  def self.add_filters
    Devise::SessionsController.after_filter do
      user_session[:token] = current_user.encrypted_id(params[:user][:password]) if current_user and params[:user] and params[:user][:password]
    end
    
    Devise::RegistrationsController.after_filter do
      user_session[:token] = current_user.encrypted_id(params[:user][:password]) if current_user and params[:user] and params[:user][:password]
    end
  end

  self.add_filters
end
