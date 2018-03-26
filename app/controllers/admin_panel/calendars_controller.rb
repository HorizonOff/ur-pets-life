module AdminPanel
  class CalendarsController < AdminPanelController
    before_action :set_vet, except: %i[update destroy]
    before_action :set_calendar, only: %i[update destroy]

    def index; end

    def create
      calendar = @vet.calendars.new(calendar_params)
      if calendar.save
        render json: { id: calendar.id }
      else
        render json: { errors: calendar.errors.full_messages }, status: 422
      end
    end

    def update
      if @calendar.update(calendar_params)
        render json: { message: 'Schedule successfully updated' }
      else
        render json: { errors: @calendar.errors.full_messages }, status: 422
      end
    end

    def destroy
      if @calendar.destroy
        render json: { message: 'Schedule successfully deleted' }
      else
        render json: { errors: @calendar.errors.full_messages }, status: 422
      end
    end

    def timeline
      render json: @vet.calendars.where(start_at: Time.zone.parse(params[:start])..Time.zone.parse(params[:end])),
             each_serializer: AdminPanle::CalendarSerializer, adapter: :attributes
    end

    def appointments
      appointments = @vet.appointments.where(status: params[:status].to_sym,
                                             start_at: Time.zone.parse(params[:start])..Time.zone.parse(params[:end]))
      render json: appointments, each_serializer: AdminPanle::AppointmentCalendarSerializer, adapter: :attributes
    end

    private

    def set_vet
      @vet = Vet.find_by(id: params[:vet_id])
    end

    def set_calendar
      @calendar = Calendar.find_by(id: params[:id])
    end

    def calendar_params
      params.permit(:start_at, :end_at)
    end
  end
end
