module PushSending
  class NotificationService < PushSending::BaseService
    def initialize(notification)
      @notification = notification
      @user = notification.user
    end

    private

    attr_reader :notification, :user

    def ios_options
      { alert: notification.message,
        sound: 'default',
        badge: unread_notifications_count }
    end

    def android_options
      {
        collapse_key: 'type_a',
        data: { body: notification.message,
                title: 'UrPetsLife',
                badge: unread_notifications_count }
      }
    end
  end
end
