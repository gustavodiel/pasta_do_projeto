class ImageProcessJob
  include Sidekiq::Worker

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
  end
end
