class ImageChannel < ApplicationCable::Channel
  def subscribed
    image = Image.find(params['image_id'])

    stream_for(image) if image.user == current_user
  end
end
