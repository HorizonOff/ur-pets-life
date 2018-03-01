module Api
  module V1
    class ClinicsController < Api::BaseController
      skip_before_action :authenticate_user
      before_action :set_clinic, except: :index

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

      def vets
        pet_type_ids = @user.pets.owned.where(id: params[:pet_ids]).pluck(:pet_type_id).uniq

        render json: @clinic.vets.with_pet_types(pet_type_ids), each_serialiser: VetIndexSerializer
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
