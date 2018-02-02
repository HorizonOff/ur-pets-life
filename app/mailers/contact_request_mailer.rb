class ContactRequestMailer < ApplicationMailer
  def send_contact_request(contact_request)
    @contact_request = contact_request
    mail(to: ENV['ADMIN'], subject: "New Contact Request from : #{contact_request.email}")
  end

  def send_reply(contact_request, message)
    @message = message
    mail(to: contact_request.email, subject: 'New Reply on Your request')
  end
end
