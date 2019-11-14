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
        source_type: on_the_way_order,
        badge: ios_badge,
        unread_commented_appointments_count: unread_commented_appointments_count,
        unread_notifications_count: unread_notifications_count,
        unread_post_comments_count: unread_post_comments_count }
    end

    def android_options
      {
        collapse_key: 'type_a',
        data: { body: notification.message,
                title: 'UrPetsLife',
                badge: android_badge,
                source_type: on_the_way_order,
                unread_commented_appointments_count: unread_commented_appointments_count,
                unread_notifications_count: unread_notifications_count,
                unread_post_comments_count: unread_post_comments_count }
      }
    end
  end
end
