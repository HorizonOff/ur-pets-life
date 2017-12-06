class VetSerializer < ActiveModel::Serializer
  type 'vet'

  attributes :id, :name, :avatar, :mobile_number, :consultation_fee, :clinic_picture, :pet_type_ids, :experience,
             :specializations
  has_many :qualifications

  def clinic_picture
    object.clinic.picture
  end

  def specializations
    object.specializations.pluck(:name)
  end

  class QualificationSerializer < ActiveModel::Serializer
    attributes :diploma, :university
  end
end
