module Api
  module V1
    class AppointmentsController < Api::BaseController
      before_action :set_appointment, except: %i[index create]

      def index
        appointments = @user.appointments
        render json: appointments, each_serializer: AppointmentIndexSerializer
      end

      def show
        render json: @appointment
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
        params.require(:appointment).permit(:bookable_type, :bookable_id, :vet_id, :booked_at, :pet_id, :comment)
      end
    end
  end
end
