module Api
  module V1
    class VaccineTypesController < Api::V1::PetTypesController
      before_action :set_pet_type
      def index
        render json: @pet_type.vaccine_types
      end
    end
  end
end
