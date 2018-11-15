class EmailCommentJob
  include SuckerPunch::Job

  def perform(appointment_id)
    ActiveRecord::Base.connection_pool.with_connection do
      AppointmentMailer.inform_about_comment(appointment_id).deliver
    end
  end
end
