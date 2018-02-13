module Api
  module V1
    class ClinicsController < Api::BaseController
      skip_before_action :authenticate_user
      before_action :set_clinic, only: :show

      def index
        clinics = clinics_query.find_objects
        serialized_clinics = ActiveModel::Serializer::CollectionSerializer.new(
          clinics, serializer: ClinicIndexSerializer, scope: serializable_params
        )

        render json: { clinics: serialized_clinics, total_count: clinics.total_count }
      end

      def show
        favorite = @clinic.favorites.find_by(user: @user)

        render json: @clinic, scope: serializable_params.merge(favorite: favorite)
      end

      private

      def set_clinic
        @clinic = Clinic.find_by_id(params[:id])
        return render_404 unless @clinic
      end

      def clinics_query
        @clinics_query ||= ::Api::V1::LocationBasedQuery.new('Clinic', params)
      end
    end
  end
end
