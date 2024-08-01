module AuthToken
  def update_auth_token
    token = generate_jwt_token(id: id, exp: 1.week.from_now.to_i)

    update_columns(authentication_token: token)
  end

  def generate_jwt_token(id:, exp: nil)
    payload = {
      id: id
    }
    payload[:exp] = exp if exp
    JWT.encode(payload, Rails.application.secrets.secret_key_base)
  end
end