module Api
  module V1
    class GroomingCentresController < Api::BaseController
      before_action :set_grooming_centre, only: :show
      def index
        grooming_centres = GroomingCentre.all
        render json: grooming_centres, each_serializer: GroomingCentreIndexSerializer
      end

      def show
        render json: @grooming_centre, include: 'service_types,service_types.service_details'
      end

      private

      def set_grooming_centre
        @grooming_centre = GroomingCentre.find_by_id(params[:id])
        return render_404 unless @grooming_centre
      end
    end
  end
end
