module PushSending
  class BaseService
    def send_push
      sessions = user.sessions
      ios_push_tokens = sessions.where(device_type: 'ios').pluck(:push_token).compact.uniq
      android_push_tokens = sessions.where(device_type: 'android').pluck(:push_token).compact.uniq
      send_push_to_ios(ios_push_tokens)
      send_push_to_android(android_push_tokens)
    end

    private

    def send_push_to_ios(tokens)
      return if tokens.blank?
      password = nil

      notification = RubyPushNotifications::APNS::APNSNotification.new(tokens, aps: ios_options)
      pusher = RubyPushNotifications::APNS::APNSPusher.new(
        File.read("#{Rails.root}/app/certificates/certificate.pem"),
        ENV['APPLE_PUSH_ENV'] == 'sandbox',
        password
      )

      pusher.push [notification]
    end

    def send_push_to_android(tokens)
      return if tokens.blank?

      fcm = FCM.new(ENV['FCM_SERVER_KEY'])
      fcm.send(tokens, android_options)
    end

    def ios_badge
      @ios_badge ||= unread_notifications_count + unread_commented_appointments_count + unread_post_comments_count
    end

    def android_badge
      @android_badge ||= unread_notifications_count + unread_commented_appointments_count + unread_post_comments_count
    end

    def unread_notifications_count
      @unread_notifications_count ||= user.unread_notifications.count
    end

    def unread_commented_appointments_count
      @unread_commented_appointments_count ||= (user.unread_commented_appointments_count +
                                                user.unread_commented_orders_count)
    end

    def on_the_way_order(order)
      return if order.blank? || order.order_status_flag_on_the_way?
      'OpenMap'
    end

    def unread_post_comments_count
      @unread_post_comments_count ||= user.unread_post_comments_count
    end
  end
end
