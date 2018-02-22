module Api
  module V1
    class LostAndFoundQuery
      def initialize(params)
        @params = params
        @search = params[:search]
        self.scope = params[:found] == 'true' ? Pet.found : Pet.lost
      end

      def find_objects
        check_search_params
        objects = if params[:latitude].present? && params[:longitude].present?
                    objects_by_location_attributes
                  else
                    all_objects
                  end
        objects.includes(:location).page(params[:page])
      end

      private

      attr_reader :params, :search
      attr_accessor :scope

      def objects_by_location_attributes
        objects = scope.joins(:location).near([params[:latitude], params[:longitude]], 999_999, units: :km)
        if search.present?
          objects = objects.where('description ILIKE :search', search: "%#{search}%").or(objects.where(id: @ids))
        end

        objects
      end

      def all_objects
        objects = if search.present?
                    scope.where('description ILIKE :search', search: "%#{search}%").or(scope.where(id: @ids))
                  else
                    scope
                  end

        objects.alphabetical_order
      end

      def check_search_params
        return if search.blank?

        search_field = search.split(',').join(' ').squish
        @ids = scope.joins(:location)
                    .where("(locations.city || ' ' || locations.area || ' ' || locations.street || ' ' ||
                             locations.building_name || ' ' || locations.unit_number || ' ' || locations.villa_number)
                             ILIKE :search_field", search_field: "%#{search_field}%").pluck(:id)
      end
    end
  end
end
