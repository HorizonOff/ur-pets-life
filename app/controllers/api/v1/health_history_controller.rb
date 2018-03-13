module Api
  module V1
    class HealthHistoryController < PetsController
      before_action :set_pet

      def index
        appointments = @pet.appointments.past.for_clinic.includes(:bookable, bookable: %i[location schedule])
                           .page(params[:page])
        serialized_appointments = ActiveModel::Serializer::CollectionSerializer.new(
          appointments, serializer: AppointmentIndexSerializer, scope: serializable_params
        )

        render json: { appointments: serialized_appointments, total_count: appointments.total_count }
      end

      private

      def appointments_pagination_query
        @appointments_pagination_query ||= ::Api::V1::AppointmentsPaginationQuery.new(@pet.past_clinic_appointments,
                                                                                      params[:page], params[:past])
      end
    end
  end
end
