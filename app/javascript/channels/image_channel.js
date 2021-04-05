import consumer from "./consumer"

function applyToObject(object, animation) {
  object.animate(animation, 500)
}

function applyImageData(data) {
  applyToObject($('#card'),{ backgroundColor: data.background_color })
  applyToObject($('#card-title'),{ color: data.detail_color })
  applyToObject($('#first-text'),{ color: data.primary_color })
  applyToObject($('#second-text'),{ color: data.secondary_color })
}

document.addEventListener('turbolinks:load', () => {
  let image_id = $('#image-id').data('image-id');

  if (window.cable.image_channel) {
    window.cable.image_channel.unsubscribe();
    delete window.cable.image_channel;
  }

  if (image_id) {
    window.cable.image_channel = consumer.subscriptions.create({channel: "ImageChannel", image_id: image_id}, {
      received(data) {
        console.log(data)
        applyImageData(data)
      }
    })
  }
})
