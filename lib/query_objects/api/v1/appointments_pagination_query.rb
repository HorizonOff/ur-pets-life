module Api
  module V1
    class AppointmentsPaginationQuery
      def initialize(scope, page, past = nil)
        @scope = scope
        @page = page
        @past = past
      end

      def find_objects
        appointments = if past == 'true'
                         scope.past
                       else
                         scope.upcoming
                       end
        appointments.includes(:bookable, bookable: %i[location schedule]).page(page)
      end

      private

      attr_reader :scope, :page, :past
    end
  end
end
