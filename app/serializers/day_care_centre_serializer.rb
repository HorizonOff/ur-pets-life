class DayCareCentreSerializer < ServiceCentreSerializer
  type 'day_care_centre'

  has_many :service_option_details

  attribute :service_types do
    scope[:service_types]
  end
end
