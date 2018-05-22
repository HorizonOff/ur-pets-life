module Reminders
  class CatVaccinationsService < Reminders::BaseService
    def pet_vaccine_types
      {
        'Rhinotracheitis / Tricat' => { fixed_time_intervals: [8.weeks, 4.weeks], recurring_time_interval: 1.year },
        'Leukemia'                 => { fixed_time_intervals: [8.weeks, 4.weeks], recurring_time_interval: 1.year },
        'Rabies'                   => { fixed_time_intervals: [], recurring_time_interval: 1.year },
        'Deworming'                => { fixed_time_intervals: [], recurring_time_interval: 6.months }
      }
    end
  end
end
