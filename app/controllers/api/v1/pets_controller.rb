module Api
  module V1
    class PetsController < Api::BaseController
      include ParamsCleanerHelper
      before_action :set_pet, only: %i[show update destroy]
      before_action :clear_pet_params, only: :update

      def index
        pets = @user.pets
        render json: pets, each_serializer: PetIndexSerializer
      end

      def show
        render json: @pet, include: 'breed,vaccine_types,vaccinations,pictures,vaccine_types.vaccinations',
               scope: { pet_vaccinations: pet_vaccinations }
      end

      def create
        pet = @user.pets.new(pet_params)
        if pet.save
          render json: { message: 'Pet created successfully' }
        else
          render_422(parse_errors_messages(pet))
        end
      end

      def update
        if @pet.update(pet_params.except(:pet_type_id))
          render json: { message: 'Pet updated successfully' }
        else
          render_422(parse_errors_messages(@pet))
        end
      rescue ActiveRecord::RecordNotFound => exception
        render_404(exception.message)
      end

      def destroy
        @pet.destroy
        render json: { nothing: true }, status: 204
      end

      def can_be_lost
        pets = @user.pets.can_be_lost
        render json: pets, each_serializer: PetIndexSerializer
      end

      def can_be_adopted
        pets = @user.pets.can_be_adopted
        render json: pets, each_serializer: PetIndexSerializer
      end

      private

      def set_pet
        @pet = @user.pets.find_by_id(params[:id])
        return render_404 unless @pet
      end

      def pet_params
        params.require(:pet).permit(:avatar, :name, :birthday, :sex, :pet_type_id, :breed_id, :additional_type, :weight,
                                    :comment, :is_lost, :is_found, :is_for_adoption,
                                    pictures_attributes: %i[id attachment _destroy],
                                    vaccinations_attributes: %i[id vaccine_type_id done_at
                                                                picture remove_picture _destroy])
      end

      def pet_vaccinations
        @pet.vaccinations.group_by(&:vaccine_type_id)
      end
    end
  end
end
