module Api
  module V1
    class LocationBasedQuery
      def initialize(model, params)
        @model = model
        @params = params

        @scope = model.constantize.all
      end

      def find_objects
        objects = if params[:latitude].present? && params[:longitude].present?
                    objects_by_location_attributes
                  else
                    all_objects
                  end
        objects.page(params[:page])
      end

      private

      attr_reader :model, :params, :scope

      def objects_by_location_attributes
        array_of_objects = objects_with_location + objects_without_location

        Kaminari.paginate_array(array_of_objects)
      end

      def objects_with_location
        objects = scope.left_joins(:location).near([params[:latitude], params[:longitude]], 999_999, units: :km)
        include_relations(objects)
      end

      def objects_without_location
        objects = scope.left_joins(:location).where(locations: { latitude: nil, longitude: nil })
        include_relations(objects)
      end

      def all_objects
        objects = scope.alphabetical_order
        include_relations(objects)
      end

      def include_relations(objects)
        if model == 'Trainer'
          objects.includes(:location)
        else
          objects.includes(:location, :schedule)
        end
      end
    end
  end
end
