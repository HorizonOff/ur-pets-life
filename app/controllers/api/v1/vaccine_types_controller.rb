module Api
  module V1
    class VaccineTypesController < Api::BaseController
      def index
        return render_404 unless params[:pet_category].in?(%w[cat dog other])
        vaccine_types = VaccineType.where("'#{params[:pet_category]}' = ANY (pet_categories)")
        render json: vaccine_types, adapter: :json
      end
    end
  end
end
