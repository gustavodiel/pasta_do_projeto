class User::PasswordlessLoginController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[login]

  def allow_login
    login = Login.find_by(token: params[:token], user: current_user)

    LoginChannel.broadcast_to(login, { url: do_login_url(Base64.urlsafe_encode64(login.token)) })

    head 200
  end

  def login
    token = Base64.urlsafe_decode64(params[:token])
    login = Login.find_by!(token: token)

    sign_in(:user, login.user)

    login.destroy

    redirect_to :home
  end
end
