class ClinicSerializer < ServiceCentreSerializer
  type 'clinic'

  attribute :consultation_fee
  has_many :vets do
    object.vets.includes(:pet_types)
  end

  class VetSerializer < BaseMethodsSerializer
    attributes :id, :name, :avatar_url, :experience, :consultation_fee, :pet_type_ids

    def avatar_url
      object.avatar.try(:url)
    end
  end
end
