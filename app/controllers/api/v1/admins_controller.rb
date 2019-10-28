module Api
  module V1
    class AdminsController < Api::BaseController

      def index
        @admin = Admin.where(role: params[:role])
        render json: @admin.as_json(only: [:id, :name])
      end

      def live_location
        @admin = current_user
        if @admin.update(location_params)
          render json: { Message: 'Location updated' }
        else
          render_422(message: 'Incorrect location params. Please try again.')
        end
      end

      private

      def location_params
        params.require(:admin).permit(:lat, :lng)
      end
    end
  end
end