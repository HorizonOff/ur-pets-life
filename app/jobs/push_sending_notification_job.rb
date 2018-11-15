class PushSendingNotificationJob
  include SuckerPunch::Job

  def perform(id)
    ActiveRecord::Base.connection_pool.with_connection do
      @notification = Notification.find_by(id: id)
      push_sending_service.send_push
    end
  end

  private

  def push_sending_service
    @push_sending_service ||= ::PushSending::NotificationService.new(@notification)
  end
end
