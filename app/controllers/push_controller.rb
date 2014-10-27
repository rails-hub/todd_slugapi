class PushController < ApplicationController

  # This is strictly used to send push notifications

  def self.push_message_to_user(message, user)
    self.push_message_to_users(message, [user])
  end

  def self.push_message_to_users(message, users)
    APNS.host = 'gateway.sandbox.push.apple.com'
    APNS.pem = "#{Rails.root}/SlugBuggy.pem"
    APNS.port = 2195

    notifications = []
    users.each do |user|
      if !user.device_token.nil?
        notification = APNS::Notification.new(user.device_token, message)
        notifications << notification
      end
    end

    puts APNS.send_notifications(notifications)
  end

end
