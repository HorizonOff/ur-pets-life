namespace :vet_calendars do
  desc 'Daily generation time_slots for vets'
  task daily_generation: :environment do
    Vet.all.includes(:clinic, clinic: :schedule).each do |vet|
      ::CalendarGeneration::DailyService.new(vet).generate_vet_time_slots
    end
  end

  task default_generation: :environment do
    Vet.all.includes(:clinic, clinic: :schedule).each do |vet|
      ::CalendarGeneration::BaseService.new(vet).generate_vet_time_slots
    end
  end
end
