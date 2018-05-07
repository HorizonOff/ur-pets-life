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
        render json: @appointment, scope: serializable_params.merge(pets_services: pets_services,
                                                                    pets_diagnoses: pets_diagnoses),
               include: 'vet,service_option_details,pets,pets.service_details,pets.diagnosis'
      end

      def create
        @appointment = @user.appointments.new(appointment_params)
        check_dates
        if @appointment.save
          render json: { message: 'Appointment created successfully' }
        else
          render_422(parse_errors_messages(@appointment))
        end
      rescue NameError
        render_422(bookable_type: 'Bookable type is invalid')
      end

      def destroy
        @appointment.destroy
        render json: { nothing: true }, status: 204
      end

      def cancel
        return render_422(status: 'Cant be changed') if @appointment.canceled? || @appointment.start_at <= Time.current
        if @appointment.update(status: :canceled)
          render json: { message: 'Appointment canceled' }
        else
          render_422(parse_errors_messages(@appointment))
        end
      end

      private

      def check_dates
        return if params[:appointment][:dates].blank?
        dates = []
        params[:appointment][:dates].each do |int_date|
          parsed_time = Time.zone.at(int_date.to_i)
          dates << parsed_time
        end
        @appointment.dates = dates.sort
      end

      def set_appointment
        @appointment = @user.appointments.find_by_id(params[:id])
        return render_404 unless @appointment
      end

      def appointment_params
        params.require(:appointment).permit(:bookable_type, :bookable_id, :vet_id, :start_at, :number_of_days, :comment,
                                            pet_ids: [],
                                            cart_items_attributes: %i[pet_id serviceable_type serviceable_id service_option_time_id])
      end

      def appointments_pagination_query
        @appointments_pagination_query ||= ::Api::V1::AppointmentsPaginationQuery.new(@user.appointments,
                                                                                      params[:page], params[:past])
      end

      def pets_diagnoses
        @appointment.diagnoses.group_by(&:pet_id)
      end

      def pets_services
        @appointment.cart_items.where(serviceable_type: 'ServiceDetail').group_by(&:pet_id)
      end
    end
  end
end
