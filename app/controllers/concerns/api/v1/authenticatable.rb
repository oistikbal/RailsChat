module Api::V1::Authenticatable
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_user!
  end

  def login!(email:, password:)
    raise Api::V1::Errors::AuthenticationError if email.nil?

    user = User.find_by(email: email)
    raise Api::V1::Errors::AuthenticationError if user.nil?

    unless user.valid_password?(password)
      raise Api::V1::Errors::AuthenticationError
    end

    user.update_auth_token
    user.authentication_token
  end

  def authenticate_user!
    raise Api::V1::Errors::AuthenticationError, 'Unauthenticated' if current_user.nil?
  end

  def current_user
    return @current_user if @current_user.present?
    return nil if decoded_jwt['id'].nil?

    @current_user = User.find_by(id: decoded_jwt['id'])
  end

  def current_account
    current_user&.account
  end

  def user_signed_in?
    current_user.present?
  end

  private

  def decoded_jwt
    JWT.decode(jwt_token, Rails.application.secrets.secret_key_base)&.first
  rescue JWT::ExpiredSignature
    raise Api::V1::Errors::AuthenticationError, 'Token Expired'
  rescue JWT::DecodeError
    {}
  end

  def jwt_token
    _, token = request.headers['Authorization']&.to_s&.split(' ')
    token
  end
end