module AdminPanel
  class AdminPanelController < ApplicationController
    include Pundit
    before_action :authenticate_admin!

    rescue_from Pundit::NotAuthorizedError, with: :not_allowed

    private

    def pundit_user
      current_admin
    end

    def not_allowed
      redirect_to root_path
    end
  end
end
