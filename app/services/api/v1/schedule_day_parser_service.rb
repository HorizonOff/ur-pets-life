module Api
  module V1
    class ScheduleDayParserService
      def initialize(schedule, date)
        self.schedule = schedule
        self.date = date
        self.valid_start = Time.current
      end

      def retrieve_time_slots
        return [] if valid_start > @date
        time_slots = []
        (1..31).each do |i|
          time_slot = {}
          time_slot[:start_at] = date.to_i
          time_slot[:number_of_days] = i
          time_slot[:end_at] = (@date + (i - 1).days).to_i
          time_slots << time_slot
        end
        time_slots
      end

      private

      attr_accessor :schedule, :date, :valid_start
    end
  end
end
