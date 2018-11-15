module AppointmentServices
  class AppointmentReminderService
    def initialize(model)
      @model = model
      self.appointments = ::AppointmentsQuery::AppointmentsForRemindersQuery.new(model).find_objects
    end

    def send_reminder
      appointments.find_each do |a|
        a.notifications.create(user_id: a.user_id, message: "Don't forget about your appointment")
      end
    end

    private

    attr_reader :model
    attr_accessor :appointments
  end
end
