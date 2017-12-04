module Api
  module V1
    class BreedsController < Api::V1::PetTypesController
      before_action :set_pet_type

      def index
        render json: @pet_type.breeds, adapter: :json
      end
    end
  end
end
