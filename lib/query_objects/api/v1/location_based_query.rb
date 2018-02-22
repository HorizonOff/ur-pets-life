module Api
  module V1
    class LocationBasedQuery
      def initialize(model, params)
        @model = model
        @params = params

        @scope = model.constantize.all
      end

      def find_objects
        check_search_params
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

        Kaminari.paginate_array(array_of_objects.uniq)
      end

      def objects_with_location
        objects = scope.left_joins(:location).near([params[:latitude], params[:longitude]], 999_999, units: :km)
        objects = objects.where('name ILIKE :search', search: "%#{params[:search]}%").or(objects.where(id: @ids)) if params[:search].present?
        include_relations(objects)
      end

      def objects_without_location
        objects = scope.left_joins(:location).where(locations: { latitude: nil, longitude: nil })
        objects = objects.where('name ILIKE :search', search: "%#{params[:search]}%").or(objects.where(id: @ids)) if params[:search].present?
        include_relations(objects)
      end

      def all_objects
        objects = if params[:search].present?
                    scope.where('name ILIKE :search', search: "%#{params[:search]}%").or(scope.where(id: @ids))
                  else
                    scope.alphabetical_order
                  end
        include_relations(objects)
      end

      def include_relations(objects)
        if model == 'Trainer'
          objects.includes(:location)
        else
          objects.includes(:location, :schedule)
        end
      end

      def check_search_params
        return if params[:search].blank?
        search_field = params[:search].split(',').join(' ').squish
        @ids = scope.joins(:location)
                    .where("(locations.city || ' ' || locations.area || ' ' || locations.street || ' ' || locations.building_name || ' ' || locations.unit_number || ' ' || locations.villa_number) ILIKE :search_field", search_field: "%#{search_field}%").pluck(:id)
      end
    end
  end
end
