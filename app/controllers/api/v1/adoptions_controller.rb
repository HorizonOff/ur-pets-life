module Api
  module V1
    class AdoptionsController < Api::BaseController
      skip_before_action :authenticate_user
      before_action :set_pet, only: :show

      def index
        pets = pets_query.find_objects
        serialized_pets = ActiveModel::Serializer::CollectionSerializer.new(
          pets, serializer: AdoptionIndexSerializer, scope: serializable_params
        )

        render json: { pets: serialized_pets, total_count: pets.total_count }
      end

      def show
        render json: @pet, serializer: AdoptionSerializer,
               include: 'breed,vaccine_types,vaccinations,vaccine_types.vaccinations,pictures',
               scope: serializable_params.merge(pet_vaccinations: pet_vaccinations)
      end

      private

      def set_pet
        @pet = Pet.for_adoption.find_by_id(params[:id])
        return render_404 unless @pet
      end

      def pet_vaccinations
        @pet.vaccinations.group_by(&:vaccine_type_id)
      end

      def pets_query
        @pets_query ||= ::Api::V1::LocationBasedPetsQuery.new(Pet.for_adoption, params)
      end
    end
  end
end
