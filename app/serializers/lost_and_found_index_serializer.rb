class LostAndFoundIndexSerializer < BaseMethodsSerializer
  type 'pet'

  attributes :id, :description, :avatar_url, :address, :distance, :pet_type_id, :lost_at, :found_at

  def lost_at
    object.lost_at.to_i if object.lost_at.present?
  end

  def found_at
    object.found_at.to_i if object.found_at.present?
  end
end
