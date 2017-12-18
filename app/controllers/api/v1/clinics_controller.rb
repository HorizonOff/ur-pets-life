module Api
  module V1
    class ClinicsController < Api::BaseController
      skip_before_action :authenticate_user
      before_action :set_clinic, only: :show

      def index
        clinics = clinics_query.find_objects
        serialized_clinics = ActiveModel::Serializer::CollectionSerializer.new(
          clinics, serializer: ClinicIndexSerializer,
                   scope: { latitude: params[:latitude], longitude: params[:longitude] }
        )

        render json: { clinics: serialized_clinics, total_count: clinics.total_count }
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
        @clinics_query ||= ::Api::V1::LocationBasedQuery.new(Clinic.all, params)
      end
    end
  end
end
