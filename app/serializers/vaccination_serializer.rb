class VaccinationSerializer < BaseMethodsSerializer
  attributes :id, :vaccine_type_id, :done_at, :picture_url, :remove_picture

  def done_at
    object.done_at.to_i
  end
end
