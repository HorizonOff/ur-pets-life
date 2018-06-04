module AppointmentsQuery
  class PastAppointmentsQuery
    def initialize(model)
      @model = model
      @current_time = Time.current
    end

    def find_objects
      Appointment.pending.where(bookable_type: model).where('start_at < ?', current_time)
    end

    private

    attr_reader :model, :current_time
  end
end
