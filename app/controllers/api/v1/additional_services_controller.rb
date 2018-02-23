module Api
  module V1
    class AdditionalServicesController < Api::BaseController
      skip_before_action :authenticate_user
      before_action :set_additional_service, only: :show

      def index
        additional_services = additional_services_query.find_objects
        serialized_additional_services = ActiveModel::Serializer::CollectionSerializer.new(
          additional_services, serializer: AdditionalServiceIndexSerializer, scope: serializable_params
        )

        render json: { additional_services: serialized_additional_services,
                       total_count: additional_services.total_count }
      end

      def show
        favorite = @additional_service.favorites.find_by(user: @user)

        render json: @additional_service, scope: serializable_params.merge(favorite: favorite)
      end

      private

      def set_additional_service
        @additional_service = AdditionalService.find_by_id(params[:id])
        return render_404 unless @additional_service
      end

      def additional_services_query
        @additional_services_query ||= ::Api::V1::LocationBasedQuery.new('AdditionalService', params)
      end
    end
  end
end
