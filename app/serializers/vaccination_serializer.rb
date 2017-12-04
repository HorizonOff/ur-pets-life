class VaccinationSerializer < ActiveModel::Serializer
  attributes :id, :vaccine_type_id, :done_at, :picture

  def done_at
    object.done_at.utc.iso8601
  end

  def picture
    object.picture.try(:url)
  end
end
