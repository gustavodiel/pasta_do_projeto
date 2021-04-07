import consumer from "./consumer"

function applyImageListData(dom, data) {
  dom.html($.parseHTML(data))
}

document.addEventListener('turbolinks:load', () => {
  let image_list_dom = $('#image-list')

  if (window.cable.image_list_channel) {
    window.cable.image_list_channel.unsubscribe();
    delete window.cable.image_list_channel;
  }

  if (image_list_dom) {
    window.cable.image_list_channel = consumer.subscriptions.create({ channel: "ImageListChannel" }, {
      received(data) {
        applyImageListData(image_list_dom, data)
      }
    })
  }
})
