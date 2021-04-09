class Notification
  attr_accessor :title, :message, :action_title, :action_url, :created_at, :image

  def initialize(title:, message:, action_title:, action_url:, image: nil)
    self.title = title
    self.message = message
    self.action_title = action_title
    self.action_url = action_url
    self.image = image
    self.created_at = Time.now
  end

  def html
    ApplicationController.render(
      template: 'notifications/show',
      assigns: { notification: self },
      layout: false
    )
  end
end
