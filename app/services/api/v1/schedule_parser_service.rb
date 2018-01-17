module Api
  module V1
    class ScheduleParserService
      def initialize(schedule, date)
        self.schedule = schedule
        self.date = date
        self.valid_start = Time.current
      end

      def retrieve_time_slots
        parse_time_slots(parse_wday_schedule)
      end

      private

      attr_accessor :schedule, :date, :valid_start

      def parse_wday_schedule
        return [date.beginning_of_day, date.end_of_day] if schedule.day_and_night

        return [] if closed?

        [change_date(schedule.send(@open_at_string)), change_date(schedule.send(@close_at_string))]
      end

      def change_date(time)
        time.change(year: date.year, month: date.month, day: date.day)
      end

      def closed?
        wday = Schedule::DAYS[date.wday.to_s]
        @open_at_string = wday + '_open_at'
        @close_at_string = wday + '_close_at'
        schedule.send(@open_at_string).blank?
      end

      def parse_time_slots(working_hours)
        return [] if working_hours.blank?
        time_slots = []
        slot_start = working_hours.first
        last_available_slot = working_hours.last - 15.minutes
        loop do
          time_slots << { start_at: slot_start.to_i } if slot_start >= valid_start
          slot_start += 15.minutes
          break time_slots if slot_start > last_available_slot
        end
      end
    end
  end
end
