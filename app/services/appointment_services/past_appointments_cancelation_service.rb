module AppointmentServices
  class PastAppointmentsCancelationService
    def initialize(model)
      @model = model
      self.appointments = ::AppointmentsQuery::PastAppointmentsQuery.new(model).find_objects
    end

    def cancel_appointments
      appointments.find_each { |a| a.update_attribute(:status, :rejected) }
    end

    def cancel_without_notification
      appointments.update_all(status: :rejected)
    end

    private

    attr_reader :model
    attr_accessor :appointments
  end
end
