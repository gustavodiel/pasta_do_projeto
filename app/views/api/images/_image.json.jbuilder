json.(image, :id, :title, :detail_color, :primary_color, :secondary_color, :background_color)

if image.file.attached?
  json.original rails_blob_url(image.file, disposition: "attachment")
  json.thumbnail polymorphic_url(image.file.variant(resize_to_limit: [100, 100]))
end
