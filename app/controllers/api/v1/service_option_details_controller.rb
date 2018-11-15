module Api
  module V1
    class ServiceOptionDetailsController < Api::BaseController
      before_action :set_service_option_detail

      def time_ranges
        render json: @service_option_detail.service_option_times
      end

      private

      def set_service_option_detail
        @service_option_detail = ServiceOptionDetail.find_by_id(params[:id])
        return render_404 unless @service_option_detail
      end
    end
  end
end
