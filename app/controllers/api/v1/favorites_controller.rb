module Api
  module V1
    class FavoritesController < Api::BaseController
      before_action :set_favorite, only: :destroy

      def index
        favorites = favorites_pagination_query.find_objects
        serialized_favorites = []
        favorites.each do |f|
          serialized_favorites << serialize_favorite(f, serializable_params.merge(favorite: f, hide_fee: true))
        end

        render json: { favorites: serialized_favorites }
      end

      def create
        favorite = @user.favorites.new(favorite_params)
        if favorite.save
          render json: { favorite_id: favorite.id }
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

      def favorites_pagination_query
        @favorites_pagination_query ||= ::Api::V1::FavoritesPaginationQuery.new(@user.favorites, params)
      end

      def serialize_favorite(favorite, scope)
        serializer = favorite.favoritable_type + 'IndexSerializer'
        serializer.constantize.new(favorite.favoritable, scope: scope)
      end
    end
  end
end
