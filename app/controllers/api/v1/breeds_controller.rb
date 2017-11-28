module Api
  module V1
    class BreedsController < Api::BaseController
      def index
        return render_404 unless params[:pet_category].in?(%w[cat dog])
        breeds = Breed.where(pet_category: params[:pet_category])
        render json: breeds, adapter: :json
      end
    end
  end
end
