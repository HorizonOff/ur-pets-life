module AdminPanel
  class NextAppointmentsController < AdminPanelController
    before_action :set_appointment

    def new
      @next_appointment = @appointment.build_next_appointment
    end

    def create
      new_attributes = appointment_params.merge(@appointment.slice(:user_id, :bookable_id, :bookable_type,
                                                                   :vet_id, :status))
      @next_appointment = @appointment.build_next_appointment(new_attributes)
      @next_appointment.pet_ids = @appointment.pet_ids
      @next_appointment.save
    end

    private

    def set_appointment
      @appointment = Appointment.find_by(id: params[:appointment_id])
    end

    def appointment_params
      params.require(:appointment).permit(:start_at, :comment)
    end
  end
end
