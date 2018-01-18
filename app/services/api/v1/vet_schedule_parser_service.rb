module Api
  module V1
    class VetScheduleParserService
      def initialize(vet, date)
        self.vet = vet
        self.date = date
        self.valid_start = Time.current
      end

      def retrieve_time_slots
        day_start = date.beginning_of_day
        day_end = date.end_of_day
        @calendars = @vet.calendars.where('start_at >= :start AND end_at <= :end', start: day_start,
                                                                                   end: day_end)
        return [] if @calendars.blank?
        @appointments = @vet.appointments.without_rejected
                            .where('start_at >= :start AND end_at <= :end', start: day_start, end: day_end)
        parse_calendars
      end

      private

      attr_accessor :vet, :date, :valid_start

      def parse_calendars
        @time_slots = []
        @calendars.each do |c|
          slot_start = c.start_at
          last_available_slot = c.end_at - vet.session_duration.minutes
          parse_each_calendar(slot_start, last_available_slot)
        end
        @time_slots
      end

      def parse_each_calendar(slot_start, last_available_slot)
        loop do
          parse_time_slot(slot_start) if slot_start >= valid_start
          slot_start += 15.minutes
          break if slot_start > last_available_slot
        end
      end

      def parse_time_slot(slot_start)
        slot_end = slot_start + vet.session_duration.minutes
        overlapsing_appointments = check_appointments(slot_start, slot_end)
        return if overlapsing_appointments.present?
        time_slot = { start_at: slot_start.to_i, end_at: slot_end.to_i }
        @time_slots << time_slot
      end

      def check_appointments(slot_start, slot_end)
        @appointments.select do |a|
          (a.start_at <= slot_start && a.end_at >= slot_start) || (a.start_at <= slot_end && a.end_at >= slot_end)
        end
      end
    end
  end
end
