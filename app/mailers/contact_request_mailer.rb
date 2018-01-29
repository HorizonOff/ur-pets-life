class ContactRequestMailer < ApplicationMailer
  def send_contact_request(contact_request)
    @user_email = contact_request.user.email
    @contact_request = contact_request
    mail(to: ENV['ADMIN'], subject: "New Contact Request from : #{@user_email}")
  end

  def send_reply(contact_request, message)
    @message = message
    mail(to: contact_request.user.email, subject: 'New Reply on Your request')
  end
end
