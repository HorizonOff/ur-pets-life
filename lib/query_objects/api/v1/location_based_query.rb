module Api
  module V1
    class LocationBasedQuery
      def initialize(scope)
        @scope = scope
      end

      def find_objects(latitude, longitude)
        objects = if latitude.present? && longitude.present?
                    objects_by_location_attributes(latitude, longitude)
                  else
                    all_objects
                  end
        objects.includes(:location, :schedule)
      end

      private

      attr_reader :scope

      def objects_by_location_attributes(latitude, longitude)
        scope.joins(:location).near([latitude, longitude], 999_999, units: :km)
      end

      def all_objects
        scope
      end
    end
  end
end
