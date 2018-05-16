class PushSendingCommentJob
  include SuckerPunch::Job

  def perform(id, appointment_id)
    ActiveRecord::Base.connection_pool.with_connection do
      @comment = Comment.find_by(id: id)
      @appointment = Appointment.find_by(id: appointment_id)
      push_sending_service.send_push
    end
  end

  private

  def push_sending_service
    @push_sending_service ||= ::PushSending::CommentService.new(@comment, @appointment)
  end
end
