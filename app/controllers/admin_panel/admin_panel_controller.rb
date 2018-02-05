module AdminPanel
  class AdminPanelController < ApplicationController
    include Pundit
    before_action :authenticate_admin!

    rescue_from Pundit::NotAuthorizedError, with: :not_allowed

    private

    def super_admin?
      current_admin.is_super_admin?
    end

    def authorize_super_admin
      authorize :application, :super_admin?
    end

    def pundit_user
      current_admin
    end

    def not_allowed
      respond_to do |format|
        format.html { redirect_to root_path }
        format.json { render json: { message: 'You have no permission' }, status: 403 }
      end
    end
  end
end
