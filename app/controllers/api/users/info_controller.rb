class Api::Users::InfoController < Api::ApplicationController
  before_action :authenticate_user!, only: %i[me]

  def me; end
end
