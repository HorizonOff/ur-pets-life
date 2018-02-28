class GroomingCentreSerializer < ServiceCentreSerializer
  type 'grooming_centre'

  attribute :service_options

  attribute :service_types do
    scope[:service_types]
  end
end
