class PushSendingCommentWorker
  include Sidekiq::Worker

  def perform(id, appointment_id)
    @comment = Comment.find_by(id: id)
    @appointment = Appointment.find_by(id: appointment_id)
    push_sending_service.send_push
  end

  private

  def push_sending_service
    @push_sending_service ||= ::PushSending::CommentService.new(@comment, @appointment)
  end
end
