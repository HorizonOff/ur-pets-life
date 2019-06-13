class InvitationMailer < ApplicationMailer
  default from: ENV['MY_SECOND_HOUSE_EMAIL']

  def invite_my_second_house_member(invitation_id)
    @invitation = MySecondHouseMemberInvitation.find_by(id: invitation_id)
    delivery_options = { user_name: ENV['AWS_SMTP_USERNAME'],
                         password: ENV['AWS_SMTP_PASSWORD'],
                         address: 'email-smtp.us-west-2.amazonaws.com' }
    mail(to: @invitation.email, subject: 'Welcome to app', delivery_method_options: delivery_options)
  end
end
