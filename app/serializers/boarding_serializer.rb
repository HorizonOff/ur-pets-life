class BoardingSerializer < ServiceCentreSerializer
  type 'boarding'

  has_many :service_option_details, if: :show_service_options?

  attribute :service_types do
    scope[:service_types]
  end
end
