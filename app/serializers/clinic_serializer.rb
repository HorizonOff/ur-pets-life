class ClinicSerializer < ServiceCentreSerializer
  type 'clinic'

  attribute :consultation_fee
  has_many :vets, each_serializer: VetIndexSerializer do
    object.vets.includes(:pet_types)
  end
end
