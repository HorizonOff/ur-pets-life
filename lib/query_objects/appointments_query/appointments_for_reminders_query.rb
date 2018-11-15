module AppointmentsQuery
  class AppointmentsForRemindersQuery
    def initialize(model)
      @model = model
      @current_time = Time.current
    end

    def find_objects
      Appointment.accepted.where(bookable_type: model).where(start_at: time_range)
    end

    private

    attr_reader :model, :current_time

    def time_range
      if model == 'Clinic' || model == 'GroomingCentre'
        two_hours_time_range
      else
        during_next_day
      end
    end

    def two_hours_time_range
      (current_time + 1.hour + 30.minutes)..(current_time + 2.hours)
    end

    def during_next_day
      current_time.next_day.beginning_of_day..current_time.next_day.end_of_day
    end
  end
end
