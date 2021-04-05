import consumer from "./consumer"

function applyImageData(data) {
  const duration = 500

  $('#card').animate({ backgroundColor: data.background_color }, duration)
  $('#card-title').animate({ color: data.detail_color }, duration)
  $('#first-text').animate({ color: data.primary_color }, duration)
  $('#second-text').animate({ color: data.secondary_color }, duration)
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
        applyImageData(data)
      }
    })
  }
})
