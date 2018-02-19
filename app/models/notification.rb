class Notification < ApplicationRecord
  belongs_to :user, counter_cache: true
  belongs_to :appointment, optional: true
  belongs_to :pet, optional: true

  before_validation :set_user

  validates :message, presence: { message: 'Message is required' }

  after_create :send_push

  private

  def set_user
    self.user_id = appointment.user_id if appointment_id
  end

  def send_push
    return if Rails.env.test?
    ios_push_tokens = user.sessions.where(device_type: 'ios').pluck(:push_token).uniq
    # android_push_tokens = user.sessions.where(devise_type: 'android').pluck(:push_token).uniq
    send_push_to_ios(ios_push_tokens) if ios_push_tokens.present?
  end

  def send_push_to_ios(tokens)
    password = nil

    notification = RubyPushNotifications::APNS::APNSNotification.new(tokens, aps: { alert: message })

    pusher = RubyPushNotifications::APNS::APNSPusher.new(
      File.read("#{Rails.root}/app/certificates/aps_development.pem"),
      ENV['APPLE_PUSH_ENV'] == 'sandbox',
      password
    )

    pusher.push [notification]
  end
end
