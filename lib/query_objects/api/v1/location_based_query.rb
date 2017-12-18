module Api
  module V1
    class LocationBasedQuery
      def initialize(scope, params)
        @scope = scope
        @params = params
      end

      def find_objects
        objects = if params[:latitude].present? && params[:longitude].present?
                    objects_by_location_attributes
                  else
                    all_objects
                  end
        objects.includes(:location, :schedule).page(params[:page])
      end

      private

      attr_reader :scope, :params

      def objects_by_location_attributes
        scope.joins(:location).near([params[:latitude], params[:longitude]], 999_999, units: :km)
      end

      def all_objects
        scope.alphabetical_order
      end
    end
  end
end
