class AppointmentMailer < ApplicationMailer
  def send_email_to_establishment(appointment)
    mail(to: appointment.bookable.email, subject: 'New appointment')
  end

  def inform_about_comment(appointment_id)
    @appointment = Appointment.find_by_id(appointment_id)
    mail(to: @appointment.bookable.email, subject: 'New reply')
  end
end
