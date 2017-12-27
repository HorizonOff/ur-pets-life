module Api
  module V1
    class LostAndFoundsController < Api::BaseController
      skip_before_action :authenticate_user
      before_action :set_pet, only: :show

      def index
        pets = pets_query.find_objects
        serialized_pets = ActiveModel::Serializer::CollectionSerializer.new(
          pets, serializer: LostAndFoundIndexSerializer,
                scope: { latitude: params[:latitude], longitude: params[:longitude] }
        )

        render json: { pets: serialized_pets, total_count: pets.total_count }
      end

      def show
        render json: @pet, serializer: LostAndFoundSerializer,
               scope: { latitude: params[:latitude], longitude: params[:longitude] }
      end

      private

      def set_pet
        @pet = Pet.lost_or_found.find_by_id(params[:id])
        return render_404 unless @pet
      end

      def pets_query
        @pets_query ||= ::Api::V1::LostAndFoundQuery.new(params)
      end
    end
  end
end
