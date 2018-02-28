class DayCareCentreSerializer < ServiceCentreSerializer
  type 'day_care_centre'

  attribute :service_options

  attribute :service_types do
    scope[:service_types]
  end
end
