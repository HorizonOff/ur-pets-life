module Api
  module V1
    class LocationBasedPetsQuery
      def initialize(scope, params, is_adoption = false)
        @scope = scope
        @params = params
        @is_adoption = is_adoption
      end

      def find_objects
        @correct_location = is_adoption ? :user_location : :location

        objects = if params[:latitude].present? && params[:longitude].present?
                    objects_by_location_attributes
                  else
                    all_objects
                  end
        objects.page(params[:page])
      end

      private

      attr_reader :scope, :params, :is_adoption

      def objects_by_location_attributes
        array_of_objects = objects_with_location + objects_without_location
        Kaminari.paginate_array(array_of_objects)
      end

      def objects_with_location
        scope.joins(@correct_location).includes(@correct_location)
             .near([params[:latitude], params[:longitude]], 999_999, units: :km)
      end

      def objects_without_location
        scope.left_joins(@correct_location).includes(@correct_location)
             .where(locations: { latitude: nil, longitude: nil })
      end

      def all_objects
        scope.alphabetical_order.includes(@correct_location)
      end
    end
  end
end
