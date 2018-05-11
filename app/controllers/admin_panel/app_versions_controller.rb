module AdminPanel
  class AppVersionsController < AdminPanelController
    before_action :authorize_super_admin
    before_action :set_app_version

    def edit; end

    def update
      if @app_version.update(app_version_params)
        redirect_to admin_panel_root_path
      else
        render :edit
      end
    end

    private

    def set_app_version
      @app_version = AppVersion.first
    end

    def app_version_params
      params.require(:app_version).permit(:android_version)
    end
  end
end
