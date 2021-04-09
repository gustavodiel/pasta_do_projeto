class User::PasswordlessLoginController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[login]

  def allow_login
    puts params
    login = Login.find_by(token: params[:token], user: current_user)

    LoginChannel.broadcast_to(login, { url: do_login_url(login.user.id) })

    redirect_to home_path, notice: 'Successfully logged in!'
  end

  def login
    puts params

    user = User.find_by(id: params[:id])

    sign_in(:user, user)

    redirect_to :home
  end
end
