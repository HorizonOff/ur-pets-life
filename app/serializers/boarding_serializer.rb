class BoardingSerializer < ServiceCentreSerializer
  type 'boarding'

  has_many :service_option_details

  attribute :service_types do
    scope[:service_types]
  end
end
