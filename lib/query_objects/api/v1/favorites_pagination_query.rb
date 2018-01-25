module Api
  module V1
    class FavoritesPaginationQuery
      def initialize(scope, params)
        self.scope = scope
        @params = params
      end

      def find_objects
        check_filter.includes(:favoritable, favoritable: %i[location schedule])
      end

      private

      attr_reader :params
      attr_accessor :scope

      def check_filter
        return scope if show_all?
        scope.send(params[:filter])
      end

      def show_all?
        return true unless params[:filter].in?(%w[clinics day_care_centres grooming_centres trainers vets])
      end
    end
  end
end
