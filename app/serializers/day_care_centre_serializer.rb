class DayCareCentreSerializer < ServiceCentreSerializer
  type 'day_care_centre'

  attribute :service_options

  has_many :service_types do
    object.service_types.includes(:service_details)
  end
end
