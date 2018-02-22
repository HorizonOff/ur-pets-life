module Api
  module V1
    class LocationBasedPetsQuery
      def initialize(scope, params)
        @scope = scope
        @params = params
        @search = params[:search]
      end

      def find_objects
        # @correct_location = is_adoption ? :user_location : :location
        check_search_params

        objects = if params[:latitude].present? && params[:longitude].present?
                    objects_by_location_attributes
                  else
                    all_objects
                  end
        objects.page(params[:page])
      end

      private

      attr_reader :scope, :params, :is_adoption, :search

      def objects_by_location_attributes
        array_of_objects = objects_with_location + objects_without_location

        Kaminari.paginate_array(array_of_objects)
      end

      def objects_with_location
        objects = scope.joins(:user_location).includes(:user_location)
                       .near([params[:latitude], params[:longitude]], 999_999, units: :km)
        if search.present?
          objects = objects.where('name ILIKE :search', search: "%#{search}%").or(objects.where(id: @ids))
        end

        objects
      end

      def objects_without_location
        objects = scope.left_joins(:user_location).includes(:user_location)
                       .where(locations: { latitude: nil, longitude: nil })
        if search.present?
          objects = objects.where('name ILIKE :search', search: "%#{search}%").or(objects.where(id: @ids))
        end

        objects
      end

      def all_objects
        objects = if search.present?
                    scope.where('name ILIKE :search', search: "%#{search}%").or(scope.where(id: @ids))
                  else
                    scope
                  end
        objects.alphabetical_order.includes(:user_location)
      end

      def check_search_params
        return if search.blank?

        search_field = search.split(',').join(' ').squish
        @ids = scope.joins(:user_location)
                    .where("(locations.city || ' ' || locations.area || ' ' || locations.street || ' ' ||
                             locations.building_name || ' ' || locations.unit_number || ' ' || locations.villa_number)
                             ILIKE :search_field", search_field: "%#{search_field}%").pluck(:id)
      end
    end
  end
end
