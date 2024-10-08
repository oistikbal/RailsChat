module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_verified_user
      reject_unauthorized_connection unless current_user
    end

    protected

    def find_verified_user
      token = request.params[:token]
      puts request.params
      user = User.find_by(authentication_token: token)
      user || reject_unauthorized_connection
    end
  end
end