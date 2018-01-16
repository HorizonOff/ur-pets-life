module AdminPanel
  class AppointmentsController < AdminPanelController
    before_action :set_appointment, except: %i[index]

    def index
      @appointments = Appointment.all
    end

    def show; end

    def accept
      @appointment.update(status: :accepted)
      render :show
    end

    def reject
      @appointment.update(status: :rejected)
      render :show
    end

    private

    def set_appointment
      @appointment = Appointment.find_by(id: params[:id])
    end
  end
end
