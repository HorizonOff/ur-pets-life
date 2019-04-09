module Api
  module V1
    class PetsController < Api::BaseController
      include ParamsCleanerHelper
      before_action :set_pet, only: %i[show update destroy lost change_status]
      before_action :clear_pet_params, only: :update
      before_action :create_pet, only: %i[create found]

      def index
        pets = @user.pets.owned
        render json: pets, each_serializer: PetIndexSerializer
      end

      def show
        render json: @pet, include: 'breed,vaccine_types,vaccinations,pictures,vaccine_types.vaccinations',
               scope: { pet_vaccinations: pet_vaccinations }
      end

      def create; end

      def update
        if @pet.update(pet_params.except(:pet_type_id))
          render json: @pet, include: 'breed,vaccine_types,vaccinations,pictures,vaccine_types.vaccinations',
                 scope: { pet_vaccinations: pet_vaccinations }
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

      def found; end

      def lost
        if @pet.update(lost_params)
          render json: { message: 'Pet updated successfully' }
        else
          render_422(parse_errors_messages(@pet))
        end
      end

      def change_status
        if @pet.update(status_params)
          render json: @pet, include: 'breed,vaccine_types,vaccinations,pictures,vaccine_types.vaccinations',
                 scope: { pet_vaccinations: pet_vaccinations }
        else
          render_422(parse_errors_messages(@pet))
        end
      end

      def can_be_lost
        pets = @user.pets.can_be_lost
        render json: pets, each_serializer: PetIndexSerializer
      end

      def can_be_adopted
        pets = @user.pets.can_be_adopted
        render json: pets, each_serializer: PetIndexSerializer
      end

      def found_pets
        pets = @user.pets.found.joins(:location).near([params[:latitude], params[:longitude]], 999_999, units: :km)

        render json: pets, each_serializer: LostAndFoundIndexSerializer, scope: serializable_params
      end

      private

      def set_pet
        @pet = @user.pets.find_by_id(params[:id])
        return render_404 unless @pet
      end

      def create_pet
        pet = @user.pets.new(pet_params)
        if pet.save
          render json: pet
        else
          render_422(parse_errors_messages(pet))
        end
      end

      def pet_params
        params.require(:pet).permit(:avatar, :name, :birthday, :sex, :pet_type_id, :breed_id, :additional_type, :weight,
                                    :comment, :found_at, :additional_comment, :mobile_number, :description, :microchip,
                                    :municipality_tag, pictures_attributes: %i[id attachment _destroy],
                                                       vaccinations_attributes: vaccinations_params,
                                                        location_attributes: location_params)
      end

      def lost_params
        params.require(:pet).permit(:description, :mobile_number, :additional_comment, :lost_at,
                                    location_attributes: location_params)
      end

      def status_params
        params.require(:pet).permit(:is_lost, :is_for_adoption)
      end

      def vaccinations_params
        %i[id vaccine_type_id done_at picture remove_picture _destroy]
      end

      def location_params
        %i[latitude longitude city area street building_type building_name unit_number villa_number comment]
      end

      def pet_vaccinations
        @pet.vaccinations.group_by(&:vaccine_type_id)
      end
    end
  end
end
