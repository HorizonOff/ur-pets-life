class AdoptionIndexSerializer < BaseMethodsSerializer
  type 'pet'

  attributes :id, :name, :birthday, :avatar_url, :address, :distance, :pet_type_id

  def address
    object.user_location.try(:address)
  end

  def distance
    object.user_location.distance_to([scope[:latitude], scope[:longitude]], :km).try(:round, 2) if show_user_distance?
  end
end
