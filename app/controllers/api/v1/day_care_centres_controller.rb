module Api
  module V1
    class DayCareCentresController < Api::BaseController
      before_action :set_day_care_centre, only: :show
      def index
        day_care_centres = DayCareCentre.all
        render json: day_care_centres, each_serializer: DayCareCentreIndexSerializer
      end

      def show
        render json: @day_care_centre, include: 'service_types,service_types.service_details'
      end

      private

      def set_day_care_centre
        @day_care_centre = DayCareCentre.find_by_id(params[:id])
        return render_404 unless @day_care_centre
      end
    end
  end
end
