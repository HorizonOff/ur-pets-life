module Api
  module V1
    class ClinicsController < Api::BaseController
      before_action :set_clinic, only: :show
      def index
        binding.pry
        clinics = Clinic.all
        render json: clinics, each_serializer: ClinicIndexSerializer
      end

      def show
        render json: @clinic
      end

      private

      def set_clinic
        @clinic = Clinic.find_by_id(params[:id])
        return render_404 unless @clinic
      end
    end
  end
end
