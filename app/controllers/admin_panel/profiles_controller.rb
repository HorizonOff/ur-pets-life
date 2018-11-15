module AdminPanel
  class ProfilesController < AdminPanelController
    before_action :set_admin

    def edit; end

    def update
      if @admin.update(admin_params)
        flash[:success] = 'Profile was updated'
      else
        flash[:errorr] = "Profile wasn't updated"
      end
      redirect_to edit_admin_panel_profile_path
    end

    private

    def set_admin
      @admin = current_admin
    end

    def admin_params
      params.require(:admin).permit(:name, :email, :avatar, :remove_avatar)
    end
  end
end
