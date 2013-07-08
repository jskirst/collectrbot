class ApiSessionsController < ApiController
  def create
    if authenticate
      render json: { status: :success, email: current_user.email }
    else
      invalid_login_attempt
    end
  end
end
  