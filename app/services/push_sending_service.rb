class PushSendingService
  def initialize(comment, appointment)
    @comment = comment
    @appointment = appointment

    @user = appointment.user
  end

  def send_push
    sessions = user.sessions
    ios_push_tokens = sessions.where(device_type: 'ios').pluck(:push_token).compact.uniq
    android_push_tokens = sessions.where(device_type: 'android').pluck(:push_token).compact.uniq

    send_push_to_ios(ios_push_tokens)
    send_push_to_android(android_push_tokens)
  end

  private

  attr_reader :comment, :appointment, :user

  def send_push_to_ios(tokens)
    return if tokens.blank?
    password = nil

    notification = RubyPushNotifications::APNS::APNSNotification.new(tokens, aps: ios_options)
    pusher = RubyPushNotifications::APNS::APNSPusher.new(
      File.read(certificate_path),
      ENV['APPLE_PUSH_ENV'] == 'sandbox',
      password
    )

    pusher.push [notification]
  end

  def ios_options
    { alert: comment.message,
      sound: 'default',
      appointment_id: appointment.id,
      type: 'AppointmentComment' }
  end

  def send_push_to_android(tokens)
    return if tokens.blank?

    fcm = FCM.new(ENV['FCM_SERVER_KEY'])

    fcm.send(tokens, android_options)
  end

  def android_options
    {
      collapse_key: 'type_a',
      data: { body: comment.message,
              title: 'UrPetsLife',
              appointment_id: appointment.id,
              type: 'AppointmentComment' }
    }
  end

  def certificate_path
    if ENV['APPLE_PUSH_ENV'] == 'sandbox'
      "#{Rails.root}/app/certificates/aps_development.pem"
    else
      "#{Rails.root}/app/certificates/aps_production.pem"
    end
  end
end
