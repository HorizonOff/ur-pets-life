module AdminPanel
  class Admins::InvitationsController < Devise::InvitationsController
    private

    def after_invite_path_for(inviter, invitee = nil)
      admin_panel_admins_path
    end

    def after_accept_path_for(resource)
      admin_panel_root_path
    end
  end
end
