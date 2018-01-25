module Api
  module V1
    class FavoritesController < Api::BaseController
      before_action :set_favorite, only: :destroy

      def index; end

      def create
        favorite = @user.favorites.new(favorite_params)
        if favorite.save
          render json: { message: 'Favorite item created successfully' }
        else
          render_422(parse_errors_messages(favorite))
        end
      rescue NameError
        render_422(favoritable_type: 'Favoritable type is invalid')
      end

      def destroy
        if @favorite.destroy
          render json: { nothing: true }, status: 204
        else
          render_422(parse_errors_messages(@favorite))
        end
      end

      private

      def set_favorite
        @favorite = @user.favorites.find_by_id(params[:id])
        return render_404 unless @favorite.present?
      end

      def favorite_params
        params.require(:favorite).permit(:favoritable_type, :favoritable_id)
      end
    end
  end
end
