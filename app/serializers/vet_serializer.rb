class VetSerializer < ActiveModel::Serializer
  type 'vet'

  attributes :id, :name, :avatar_url, :mobile_number, :consultation_fee, :clinic_picture_url, :pet_type_ids, :experience,
             :specializations
  has_many :qualifications
  def avatar_url
    object.avatar.try(:url)
  end

  def clinic_picture_url
    object.clinic.picture.try(:url)
  end

  def specializations
    object.specializations.pluck(:name)
  end

  class QualificationSerializer < ActiveModel::Serializer
    attributes :diploma, :university
  end
end
