class ImagesController < ApplicationController
  before_action :set_image, only: %i[show edit update destroy]

  def index
    @images = current_user.images
  end

  def show; end

  def new
    @image = Image.new
  end

  def edit; end

  def create
    @image = Image.new(image_params)

    if @image.save
      ImageProcessJob.perform_async(@image.id)

      update_images_list

      redirect_to @image, notice: 'Imagem criada!'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @image.update(image_params)
      ImageProcessJob.perform_async(@image.id)

      update_images_list

      redirect_to @image, notice: 'Imagem atualizada!'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @image.destroy

    update_images_list

    redirect_to images_url, notice: 'Imagem deletada!'
  end

  private

  def update_images_list
    template = ApplicationController.render(
      partial: 'images/image_list',
      assigns: { images: current_user.images },
      layout: false
    )

    ImageListChannel.broadcast_to(current_user, template)
  end

  def set_image
    @image = Image.find(params[:id])
  end

  def image_params
    params.require(:image).permit(:title, :file, :user_id)
  end
end
