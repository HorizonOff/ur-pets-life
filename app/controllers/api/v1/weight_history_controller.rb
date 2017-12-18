module Api
  module V1
    class WeightHistoryController < PetsController
      before_action :set_pet

      def index
        render json: @pet.versions
      end
    end
  end
end
