class ClinicSerializer < ServiceCentreSerializer
  type 'clinic'

  attribute :consultation_fee
  has_many :vets do
    object.vets.includes(:pet_types)
  end

  class VetSerializer < ActiveModel::Serializer
    attributes :id, :name, :avatar, :experience, :consultation_fee, :pet_type_ids
  end
end
