require 'action_view'

class ImageProcessJob
  include Sidekiq::Worker
  include ActionView::Helpers::DateHelper
  include Rails.application.routes.url_helpers

  def perform(image_id)
    image = Image.find(image_id)

    colors = Colorama.extract_from_file(ActiveStorage::Blob.service.path_for(image.file.key))

    image.update(
      primary_color: "##{colors[:primary].hex}",
      secondary_color: "##{colors[:secondary].hex}",
      detail_color: "##{colors[:detail].hex}",
      background_color: "##{colors[:background].hex}"
    )

    attributes = image.attributes.slice('title', 'primary_color', 'secondary_color', 'detail_color', 'background_color')
    ImageChannel.broadcast_to(image, attributes)

    NotificationsHelper.send(
      image.user,
      {
        title: 'Image processed',
        message: "The image <strong>#{image.title}</strong> has finished in #{time_ago_in_words(image.created_at)}",
        action_title: 'Go to image',
        action_url: image_path(image),
        image: 'bi-image'
      }
    )
  end
end
