class LostAndFoundSerializer < BaseMethodsSerializer
  type 'pet'

  attributes :id, :description, :avatar_url, :address, :distance, :lost_at, :found_at, :additional_comment,
             :mobile_number

  has_one :location, key: :location_attributes

  def lost_at
    object.lost_at.to_i if object.lost_at.present?
  end

  def found_at
    object.found_at.to_i if object.found_at.present?
  end
end
