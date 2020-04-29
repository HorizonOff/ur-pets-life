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

      connection = Apnotic::Connection.development(cert_path: "#{Rails.root}/app/certificates/certificate.pem")
      connection.on(:error) { |exception| puts "Exception has been raised: #{exception}" }

      tokens.each do |token|
        notification       = Apnotic::Notification.new(token)
        notification.topic = ENV['APPLE_BUNDLE_ID']
        notification.custom_payload = { aps: ios_options }

        push = connection.prepare_push(notification)
        push.on(:response) { |response|
          if response.status == '410' ||
              (response.status == '400' && response.body['reason'] == 'BadDeviceToken')
            return Device.find_by(token: token).destroy
          end
        }

        connection.push_async(push)
      end

      connection.join
      connection.close
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
