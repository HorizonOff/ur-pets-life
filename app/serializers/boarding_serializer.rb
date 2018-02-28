class BoardingSerializer < ServiceCentreSerializer
  type 'boarding'

  attribute :service_options

  attribute :service_types do
    scope[:service_types]
  end
end
