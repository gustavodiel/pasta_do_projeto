import consumer from "./consumer"

function applyNotificationData(data) {
  let element = $.parseHTML(data)
  $('#toaster').append(element)
  $('#' + element[0].id).toast('show')
}

document.addEventListener('turbolinks:load', () => {
  if (window.cable.notification_channel) {
    return;
  }

  window.cable.notification_channel = consumer.subscriptions.create({channel: "NotificationChannel"}, {
    received(data) {
      applyNotificationData(data)
    }
  })
})
