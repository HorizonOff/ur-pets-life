module Api
  module V1
    class VetsController < Api::BaseController
      skip_before_action :authenticate_user
      before_action :set_vet

      def show
        render json: @vet
      end

      private

      def set_vet
        @vet = Vet.find_by_id(params[:id])
        return render_404 unless @vet
      end
    end
  end
end
