module Api
  module V1
    class AppVersionsController < Api::BaseController
      skip_before_action :authenticate_user

      def show
        app_version = AppVersion.first
        render json: app_version, adapter: :attributes
      end
    end
  end
end
