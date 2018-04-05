class AppointmentMailer < ApplicationMailer
  def send_email_to_establishment(appointment)
    mail(to: appointment.bookable.email, subject: 'New appointment')
  end
end
