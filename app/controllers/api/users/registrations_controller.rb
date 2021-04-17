# frozen_string_literal: true

class Api::Users::RegistrationsController < Devise::RegistrationsController
  skip_before_action :authenticate_scope!, only: %i[update destroy]
  protect_from_forgery with: :null_session

  def create
    user = User.create(user_params)

    if user.save
      @current_user = user
    else
      render json: { error: user.errors.full_messages, error_code: 2 }, status: :unprocessable_entity
    end
  end

  def update
    return unless request.headers['HTTP_AUTHORIZATION'].present?

    authenticate_or_request_with_http_token do |token|
      jwt_payload = JWT.decode(token, Rails.application.secrets.secret_key_base).first

      user = User.find(jwt_payload['id'])

      if user&.valid_password?(current_password)
        user.update(user_params)

        @current_user = user
      else
        render json: { error: 'Password does not match', error_code: 4 }, status: :unprocessable_entity
      end
    rescue JWT::ExpiredSignature, JWT::VerificationError, JWT::DecodeError => error
      render json: { error: 'Bad credentials', error_code: 3 }, status: :unauthorized
    end
  end

  def destroy
    return unless request.headers['HTTP_AUTHORIZATION'].present?

    puts 'oies'

    authenticate_or_request_with_http_token do |token|
      jwt_payload = JWT.decode(token, Rails.application.secrets.secret_key_base).first

      user = User.find(jwt_payload['id'])

      if user&.valid_password?(current_password)
        user.update(user_params)

        @current_user = user
      else
        render json: { error: 'Password does not match', error_code: 4 }, status: :unprocessable_entity
      end
    rescue JWT::ExpiredSignature, JWT::VerificationError, JWT::DecodeError => error
      render json: { error: 'Bad credentials', error_code: 3 }, status: :unauthorized
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password)
  end

  def current_password
    params.require(:user).permit(:current_password)[:current_password]
  end
end
