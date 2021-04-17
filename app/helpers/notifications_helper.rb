module NotificationsHelper
  def self.send(user, notification_attributes)
    notification = Notification.new(notification_attributes)

    NotificationChannel.broadcast_to(user, { html: notification.html, json: notification.json })
  end
end
