module CalendarGeneration
  class DailyService < CalendarGeneration::BaseService
    def initialize(vet)
      @vet = vet
      @schedule = vet.clinic.schedule

      self.day = Date.today + 59.days
    end

    def generate_vet_time_slots
      if @schedule.day_and_night?
        generate_24_7_time_slot(day)
      else
        generate_clinic_time_slot(day)
      end
    end
  end
end
