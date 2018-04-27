module CalendarGeneration
  class BaseService
    def initialize(vet)
      @vet = vet
      @schedule = vet.clinic.schedule

      self.day = Date.today
    end

    def generate_vet_time_slots
      if @schedule.day_and_night?
        60.times { generate_24_7_time_slot(day) }
      else
        60.times { generate_clinic_time_slot(day) }
      end
    end

    def generate_24_7_time_slot(date)
      beginning_of_day = date.beginning_of_day
      end_of_day = date.end_of_day
      @vet.generate_calendar(beginning_of_day, end_of_day)
      @day += 1.day
    end

    def generate_clinic_time_slot(date)
      check_wday(date)
      return if @open_at.blank?
      beginning_of_time_slot = @open_at.change(year: date.year, month: date.month, day: date.day)
      end_of_time_slot = @close_at.change(year: date.year, month: date.month, day: date.day)
      @vet.generate_calendar(beginning_of_time_slot, end_of_time_slot)
      @day += 1.day
    end

    private

    attr_reader :access_token, :schedule
    attr_accessor :day

    def check_wday(date)
      wday = date.wday
      wday_string = Schedule::DAYS[wday.to_s]
      @open_at = @schedule.send(wday_string + '_open_at')
      @close_at = @schedule.send(wday_string + '_close_at')
    end
  end
end
