class InvitationsController < ApplicationController
  def unsubscribe
    @invitation = MySecondHouseMemberInvitation.find_by(token: params[:token])
    @invitation.update_column(:unsubscribe, true)
  end
end
