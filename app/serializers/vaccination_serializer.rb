class VaccinationSerializer < ActiveModel::Serializer
  attributes :id, :vaccine_type_id, :done_at, :picture_url, :remove_picture

  def done_at
    object.done_at.utc.iso8601
  end

  def picture_url
    object.picture.try(:url)
  end

  def remmove_picture
    false
  end
end
