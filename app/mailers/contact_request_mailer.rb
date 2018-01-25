class ContactRequestMailer < ApplicationMailer
  def send_contact_request(contact_request)
    @user_email = contact_request.user.email
    @contact_request = contact_request
    mail(to: ENV['GMAIL_ADMIN'],
         subject: "New Contact Request from : #{@user_email}")
  end
end
