module Api
  module V1
    class ScheduleParserService
      def initialize(grooming_centre, date)
        self.grooming_centre = grooming_centre
        self.schedule = grooming_centre.schedule
        self.date = date
        self.valid_start = Time.current
      end

      def retrieve_time_slots
        @day_start = date.beginning_of_day
        @day_end = date.end_of_day
        @blocked_times = grooming_centre.blocked_times.where('start_at >= :start AND end_at <= :end',
                                                             start: @day_start, end: @day_end)
        parse_time_slots(parse_wday_schedule)
      end

      private

      attr_accessor :grooming_centre, :schedule, :date, :valid_start

      def parse_wday_schedule
        return [@day_start, @day_end] if schedule.day_and_night

        return [] if closed?

        [change_day(schedule.send(@open_at_string)), change_day(schedule.send(@close_at_string))]
      end

      def change_day(time)
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
        last_available_slot = working_hours.last - 30.minutes
        loop do
          time_slots << { start_at: slot_start.to_i } if slot_valid?(slot_start)
          slot_start += 15.minutes
          break time_slots if slot_start > last_available_slot
        end
      end

      def slot_valid?(slot_start)
        slot_start >= valid_start && blocked_times_blank?(slot_start)
      end

      def blocked_times_blank?(slot_start)
        slot_end = slot_start + 30.minutes
        times_array = @blocked_times.select do |bt|
          (bt.start_at <= slot_start && bt.end_at > slot_start) || (bt.start_at < slot_end && bt.end_at >= slot_end)
        end
        times_array.blank?
      end
    end
  end
end
