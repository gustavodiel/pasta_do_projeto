class Api::ImagesController < Api::ApplicationController
  before_action :authenticate_user!

  def create
    images = create_images_params[:images].map do |image_params|
      Image.create(title: image_params[:title], user: current_user).tap do |image|
        image.file.attach(image_params[:file])
      end
    end

    @results = {}

    images.each do |image|
      if image.save
        @results[:success] ||= []
        @results[:success] << image
      else
        @results[:errors] ||= []
        @results[:errors] << { image: image.title, errors: image.errors }
      end
    end
  end

  private

  def create_images_params
    params.permit(images: %i[file title])
  end
end
