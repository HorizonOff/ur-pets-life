module Api
  module V1
    class AppointmentsController < Api::BaseController
      before_action :set_appointment, except: %i[index create]

      def index
        appointments = appointments_pagination_query.find_objects
        serialized_appointments = ActiveModel::Serializer::CollectionSerializer.new(
          appointments, serializer: AppointmentIndexSerializer, scope: serializable_params
        )

        render json: { appointments: serialized_appointments, total_count: appointments.total_count }
      end

      def show
        render json: @appointment, scope: serializable_params
      end

      def create
        appointment = @user.appointments.new(appointment_params)
        if appointment.save
          render json: { message: 'Appointment created successfully' }
        else
          render_422(parse_errors_messages(appointment))
        end
      rescue NameError
        render_422(bookable_type: 'Bookable type is invalid')
      end

      def destroy
        @appointment.destroy
        render json: { nothing: true }, status: 204
      end

      private

      def set_appointment
        @appointment = @user.appointments.find_by_id(params[:id])
        return render_404 unless @appointment
      end

      def appointment_params
        params.require(:appointment).permit(:bookable_type, :bookable_id, :vet_id, :start_at, :pet_id, :comment,
                                            service_detail_ids: [])
      end

      def appointments_pagination_query
        @appointments_pagination_query ||= ::Api::V1::AppointmentsPaginationQuery.new(@user.appointments,
                                                                                      params[:page], params[:past])
      end
    end
  end
end
