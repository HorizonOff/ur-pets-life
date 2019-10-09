module Api
  module V1
    class AdminsController < Api::BaseController

      def index
        @admin = Order.where(role: params[:role])
        render json: @admin.as_json(only: [:id, :name])
      end
    end
  end
end