class InvitationWorker
  include Sidekiq::Worker

  def perform(invitation_id)
    InvitationMailer.invite_my_second_house_member(invitation_id).deliver
  end
end
