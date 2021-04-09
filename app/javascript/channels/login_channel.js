import consumer from "./consumer"

function handleLogin(data, channel) {
  console.log(data)
  window.location.replace(data.url)
}

document.addEventListener('passwordless_login', () => {
  if (window.cable.login_channel) {
    return;
  }

  console.log('Iniciated login')

  window.cable.login_channel = consumer.subscriptions.create({channel: "LoginChannel"}, {
    received(data) {
      handleLogin(data, this)
    }
  })
})
