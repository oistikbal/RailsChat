class Api::V1::SessionsController < Api::V1::ApiController
  skip_before_action :authenticate_user!, only: [:create]

  def create
    token = login!(email: sign_in_params[:email], password: sign_in_params[:password])
    render json: { authentication_token: token }
  end

  private

  def sign_in_params
    params.require(:user_login).permit(:email, :password)
  end
end
