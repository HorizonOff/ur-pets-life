module AdminPanel
  class PasswordsController < AdminPanelController
    before_action :set_admin

    def edit; end

    def update
      if @admin.valid_password?(params[:current_password])
        update_password
      else
        flash[:error] = "Current password doesn't match"
        redirect_to edit_admin_panel_password_path
      end
    end

    private

    def set_admin
      @admin = current_admin
    end

    def password_params
      params.require(:admin).permit(:password, :password_confirmation)
    end

    def update_password
      if @admin.update(password_params)
        flash[:success] = 'Password was changed'
        sign_in @admin, bypass: true
        redirect_to admin_panel_root_path
      else
        flash[:error] = "Password wasn't changed"
        redirect_to edit_admin_panel_password_path
      end
    end
  end
end
