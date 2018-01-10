module Api
  module V1
    class VetScheduleParserService
      def initialize(vet, date)
        self.vet = vet
        self.date = date
      end

      def retrieve_time_slots
        day_start = date.beginning_of_day
        day_end = date.end_of_day
        @calendars = @vet.calendars.where('start_at >= :start AND end_at <= :end', start: day_start,
                                                                                   end: day_end)
        return [] if @calendars.blank?
        @appointments = @vet.appointments.where('start_at >= :start AND end_at <= :end', start: day_start,
                                                                                         end: day_end)
        parse_time_slots(@calendars)
      end

      private

      attr_accessor :date, :vet

      def parse_time_slots(calendars)
        @time_slots = []
        calendars.each do |c|
          slot_start = c.start_at
          last_available_slot = c.end_at - vet.session_duration.minutes
          parse_each_calendar(slot_start, last_available_slot)
        end
        @time_slots
      end

      def parse_each_calendar(slot_start, last_available_slot)
        loop do
          slot_end = slot_start + vet.session_duration.minutes
          overlapsing_appointments = check_appointments(slot_start, slot_end)
          if overlapsing_appointments.blank?
            time_slot = { start_at: slot_start.strftime('%I:%M %p'), end_at: slot_end.strftime('%I:%M %p') }
            @time_slots << time_slot
          end
          slot_start += 15.minutes
          break if slot_start > last_available_slot
        end
      end

      def check_appointments(slot_start, slot_end)
        @appointments.select do |a|
          (a.start_at <= slot_start && a.end_at >= slot_start) || (a.start_at <= slot_end && a.end_at >= slot_end)
        end
      end
    end
  end
end
