# frozen_string_literal: true

class User::SessionsController < Devise::SessionsController
  # POST /resource/sign_in
  def create
    return process_empty_password if passwordless_login?

    super
  end

  private

  def process_empty_password
    atempt_user = User.find_by(email: params[:user][:email])

    login = Login.create(
      token: SecureRandom.uuid,
      user: atempt_user
    )

    NotificationsHelper.send(
      atempt_user,
      {
        title: 'New Login',
        message: "A Login request was sent from ip #{request.env['HTTP_X_FORWARDED_FOR'] || request.remote_ip}",
        action_title: 'Allow',
        action_url: allow_login_path(login.token),
        image: 'bi-box-arrow-in-right'
      }
    )

    cookies.encrypted[:login_token] = login.token

    render 'user/wait_login'
  end

  def passwordless_login?
    empty_password? && exists_user?
  end

  def exists_user?
    User.find_by(email: params[:user][:email]).present?
  end

  def empty_password?
    params[:user][:password].empty?
  end
end
