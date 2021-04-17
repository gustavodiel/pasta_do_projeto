class Api::ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session

  before_action :authenticate_user

  respond_to :json

  private

  def authenticate_user!(options = {})
    head :unauthorized unless signed_in?
  end

  def current_user
    @current_user ||= super || User.find(@current_user_id)
  end

  def signed_in?
    @current_user_id.present?
  end

  def authenticate_user
    return unless request.headers['HTTP_AUTHORIZATION'].present?

    return authenticate_user! if request.format.html?

    authenticate_or_request_with_http_token do |token|
      puts(token)
      jwt_payload = JWT.decode(token, Rails.application.secrets.secret_key_base).first

      @current_user_id = jwt_payload['id']
    rescue JWT::ExpiredSignature, JWT::VerificationError, JWT::DecodeError => error
      head :unauthorized
    end
  end
end
