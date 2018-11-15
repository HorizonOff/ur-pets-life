module AdminPanel
  module Admins
    class InvitationsController < Devise::InvitationsController
      private

      def after_invite_path_for(_inviter, _invitee = nil)
        admin_panel_admins_path
      end

      def after_accept_path_for(_resource)
        admin_panel_root_path
      end
    end
  end
end
