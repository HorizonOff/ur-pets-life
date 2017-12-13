module Api
  module V1
    class ClinicsController < Api::BaseController
      skip_before_action :authenticate_user
      before_action :set_clinic, only: :show

      def index
        clinics = clinics_query.find_objects(params[:latitude], params[:longitude])
        render json: clinics, each_serializer: ClinicIndexSerializer,
               scope: { latitude: params[:latitude], longitude: params[:longitude] }
      end

      def show
        render json: @clinic, scope: { latitude: params[:latitude], longitude: params[:longitude] }
      end

      private

      def set_clinic
        @clinic = Clinic.find_by_id(params[:id])
        return render_404 unless @clinic
      end

      def clinics_query
        @clinics_query ||= ::Api::V1::LocationBasedQuery.new(Clinic.all)
      end
    end
  end
end
