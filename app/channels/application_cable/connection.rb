module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user, :no_pw_login

    def connect
      self.current_user = find_verified_user
      self.no_pw_login = find_login

      reject_unauthorized_connection unless [current_user, no_pw_login].any?
    end

    protected

    def find_verified_user
      user_id = cookies.encrypted[:user_id]

      if user_id.blank?
        token = cookies['X-Authorization']

        jwt_payload = JWT.decode(token, Rails.application.secrets.secret_key_base).first
        user_id = jwt_payload['id']
      end

      User.find_by(id: user_id)
    end

    def find_login
      login_token = cookies.encrypted[:login_token]

      Login.find_by(token: login_token)
    end
  end
end
