class InvitationMailer < ApplicationMailer
  default from: ENV['MY_SECOND_HOUSE_EMAIL']

  def invite_my_second_house_member(invitation_id)
    @invitation = MySecondHouseMemberInvitation.find_by(id: invitation_id)
    mail(to: @invitation.email, subject: 'Welcome to app')
  end
end
