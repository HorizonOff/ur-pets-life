class MySecondHouseMemberInvitation < ApplicationRecord
  after_commit :send_invitation, on: :create

  private

  def send_invitation
    # InvitationWorker.perform_async(id)
    InvitationMailer.invite_my_second_house_member(id).deliver
  end
end
