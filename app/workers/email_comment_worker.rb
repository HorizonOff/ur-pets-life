class EmailCommentWorker
  include Sidekiq::Worker

  def perform(appointment_id)
    AppointmentMailer.inform_about_comment(appointment_id).deliver
  end
end
