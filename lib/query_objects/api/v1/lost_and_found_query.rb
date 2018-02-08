module Api
  module V1
    class LostAndFoundQuery
      def initialize(params, scope = nil)
        @params = params
        self.scope = scope
      end

      def find_objects
        lost_or_found_objects
        objects = if params[:latitude].present? && params[:longitude].present?
                    objects_by_location_attributes
                  else
                    all_objects
                  end
        objects.includes(:location).page(params[:page])
      end

      private

      attr_reader :params
      attr_accessor :scope

      def lost_or_found_objects
        @scope = if params[:found] == 'true'
                   Pet.found
                 else
                   Pet.lost
                 end
      end

      def objects_by_location_attributes
        @scope.left_joins(:location)
              .near([params[:latitude], params[:longitude]], 999_999, units: :km, order: false)
              .order('distance ASC NULLS LAST')
      end

      def all_objects
        scope.alphabetical_order
      end
    end
  end
end
