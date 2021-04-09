class LoginChannel < ApplicationCable::Channel
  def subscribed
    stream_for no_pw_login
  end

  def do_login(data)
    puts data
  end
end
