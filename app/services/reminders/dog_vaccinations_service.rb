module Reminders
  class DogVaccinationsService < Reminders::BaseService
    def pet_vaccine_types
      {
        'DHPPI'         => { fixed_time_intervals: [8.weeks, 4.weeks], recurring_time_interval: 1.year },
        'Rabies'        => { fixed_time_intervals: [], recurring_time_interval: 1.year },
        'Kennel Cough'  => { fixed_time_intervals: [], recurring_time_interval: 6.months },
        'Deworming'     => { fixed_time_intervals: [], recurring_time_interval: 6.months }
      }
    end
  end
end
