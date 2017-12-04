module Api
  module V1
    class PetsController < Api::BaseController
      include ParamsCleanerHelper
      before_action :set_pet, except: %i[index create]
      before_action :clear_pet_params, only: %i[create update]

      def index
        pets = @user.pets
        render json: pets, each_serializer: PetIndexSerializer, adapter: :json
      end

      def show
        render json: @pet, include: 'vaccine_types,vaccinations,pictures,vaccine_types.vaccinations',
               scope: { pet_vaccinations: pet_vaccinations }, adapter: :json
      end

      def create
        pet = @user.pets.new(pets_params)
        if pet.save
          render json: { message: 'Pet created successfully' }
        else
          render_422(parse_errors_messages(pet))
        end
      end

      def update
        if @pet.update(pets_params.except(:pet_type_id))
          render json: { message: 'Pet updated successfully' }
        else
          render_422(parse_errors_messages(@pet))
        end
      end

      def destroy
        @pet.destroy
        render json: { nothing: true }, status: 204
      end

      private

      def set_pet
        @pet = @user.pets.find_by_id(params[:id])
        return render_404 unless @pet
      end

      def pets_params
        params.require(:pet).permit(:name, :birthday, :sex, :pet_type_id, :breed_id, :weight, :comment, :avatar,
                                    vaccinations_attributes: %i[id vaccine_type_id done_at picture _destroy],
                                    pictures_attributes: %i[id attachment _destroy])
      end

      def pet_vaccinations
        @pet.vaccinations.group_by(&:vaccine_type_id)
      end
    end
  end
end
