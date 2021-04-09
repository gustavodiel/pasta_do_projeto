module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user, :no_pw_login

    def connect
      if env['warden'].user
        self.current_user = find_verified_user
      else
        self.no_pw_login = find_login
      end
    end

    protected

    def find_verified_user
      user_id = cookies.encrypted[:user_id]

      User.find_by(id: user_id) || reject_unauthorized_connection
    end

    def find_login
      login_token = cookies.encrypted[:login_token]

      Login.find_by(token: login_token) || reject_unauthorized_connection
    end
  end
end
