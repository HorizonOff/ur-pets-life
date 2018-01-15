module Api
  module V1
    class ScheduleParserService
      def initialize(schedule, date)
        self.schedule = schedule
        self.date = date
      end

      def retrieve_time_slots
        parse_time_slots(parse_wday_schedule)
      end

      private

      attr_accessor :schedule, :date

      def parse_wday_schedule
        return [date.beginning_of_day, date.end_of_day] if schedule.day_and_night

        return [] if closed?

        [schedule.send(@open_at_string), schedule.send(@close_at_string)]
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
          time_slots << { start_at: slot_start.strftime('%I:%M %p') }
          slot_start += 15.minutes
          break time_slots if slot_start > last_available_slot
        end
      end
    end
  end
end
