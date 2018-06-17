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
        badge: badge }
    end

    def android_options
      {
        collapse_key: 'type_a',
        data: { body: notification.message,
                title: 'UrPetsLife',
                badge: badge }
      }
    end
  end
end
