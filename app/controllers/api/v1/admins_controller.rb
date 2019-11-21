module Api
  module V1
    class AdminsController < Api::BaseController

      def index
        @admin = Admin.where(role: params[:role])
        render json: @admin.as_json(only: [:id, :name])
      end

      def last_location
        @admin = Admin.find_by_id(params[:id])
        render json: @admin.as_json(only: [:lat, :lng])
      end

      def live_location
        return if !current_user.driver? || current_user.orders.order_status_flag_on_the_way.count.zero?

        if current_user.update(location_params)
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