require 'apnotic'

class PushSendingNotificationWorker
  include Sidekiq::Worker

  def perform(id)
    @notification = Notification.find_by(id: id)
    push_sending_service.send_push
  end

  private

  def push_sending_service
    @push_sending_service ||= ::PushSending::NotificationService.new(@notification)
  end
end
