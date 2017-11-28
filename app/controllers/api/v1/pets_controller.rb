module Api
  module V1
    class PetsController < Api::BaseController
      before_action :set_pet, except: %i[index create]

      def index
        pets = @user.pets
        render json: pets, each_serializer: PetIndexSerializer, adapter: :json
      end

      def show
        render json: @pet, adapter: :json
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
        if @pet.update(pets_params)
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
        params.require(:pet).permit(:name, :birthday, :sex, :category, :breed_id, :weight, :comment)
      end
    end
  end
end
