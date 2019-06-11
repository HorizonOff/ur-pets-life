class MySecondHouseMemberInvitation < ApplicationRecord
  after_commit :send_invitation, on: :create

  private

  def send_invitation
    InvitationWorker.perform_async(id)
  end
end
