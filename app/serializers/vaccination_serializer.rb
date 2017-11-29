class VaccinationSerializer < ActiveModel::Serializer
  attributes :id, :vaccine_type_id, :done_at

  def done_at
    object.done_at.utc.iso8601
  end
end
