module Api
  module V1
    class LocationBasedPetsQuery
      def initialize(scope, params, is_adoption = false)
        @scope = scope
        @params = params
        @is_adoption = is_adoption
      end

      def find_objects
        objects = if params[:latitude].present? && params[:longitude].present?
                    objects_by_location_attributes
                  else
                    all_objects
                  end
        objects.includes(:location).page(params[:page])
      end

      private

      attr_reader :scope, :params, :is_adoption

      def objects_by_location_attributes
        correct_location = is_adoption ? :user_location : :location
        scope.left_joins(correct_location)
             .near([params[:latitude], params[:longitude]], 999_999, units: :km, order: false)
             .order('distance ASC NULLS LAST')
      end

      def all_objects
        scope.alphabetical_order
      end
    end
  end
end
