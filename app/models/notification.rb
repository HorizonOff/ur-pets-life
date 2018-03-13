class Notification < ApplicationRecord
  belongs_to :admin, optional: true
  belongs_to :user, counter_cache: true
  belongs_to :appointment, optional: true
  belongs_to :pet, optional: true

  before_validation :set_user

  validates :message, presence: true

  after_create :send_push, unless: ->(obj) { obj.skip_push_sending? }

  delegate :name, to: :user

  def self.view
    select { |n| n.viewed_at.blank? }.each do |n|
      n.update_column(:viewed_at, Time.current)
    end
  end

  private

  def set_user
    self.user_id = appointment.user_id if appointment_id
  end

  def send_push
    return if Rails.env.test?
    sessions = user.sessions
    ios_push_tokens = sessions.where(device_type: 'ios').pluck(:push_token).compact.uniq
    android_push_tokens = sessions.where(device_type: 'android').pluck(:push_token).compact.uniq

    send_push_to_ios(ios_push_tokens)
    send_push_to_android(android_push_tokens)
  end

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

  def send_push_to_android(tokens)
    return if tokens.blank?

    fcm = FCM.new(ENV['FCM_SERVER_KEY'])

    fcm.send(tokens, android_options)
  end

  def android_options
    {
      collapse_key: 'type_a',
      data: { body: message,
              title: 'UrPetsLife',
              badge: user.unread_notifications.count }
    }
  end

  def ios_options
    { alert: message, sound: 'default', badge: user.unread_notifications.count }
  end

  def certificate_path
    if ENV['APPLE_PUSH_ENV'] == 'sandbox'
      "#{Rails.root}/app/certificates/aps_development.pem"
    else
      "#{Rails.root}/app/certificates/aps_production.pem"
    end
  end
end
