module Api
  module V1
    class PetTypesController < Api::BaseController
      def index
        pet_types = PetType.all
        render json: pet_types, adapter: :json
      end

      private

      def set_pet_type
        @pet_type = PetType.find_by_id(params[:pet_type_id])
        return render_404 unless @pet_type
      end
    end
  end
end
