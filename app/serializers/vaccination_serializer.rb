class VaccinationSerializer < PictureUrlSerializer
  attributes :id, :vaccine_type_id, :done_at, :picture_url, :remove_picture

  def done_at
    object.done_at.utc.iso8601
  end
end
