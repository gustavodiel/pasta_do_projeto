# frozen_string_literal: true

class Api::Users::SessionsController < Devise::SessionsController
  protect_from_forgery with: :null_session

  def create
    user = User.find_by_email(user_params[:email])

    if user&.valid_password?(user_params[:password])
      @current_user = user
    else
      render json: { errors: { 'email or password' => ['is invalid'] } }, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:username, :email, :password, :bio, :image)
  end
end
