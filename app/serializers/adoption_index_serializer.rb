class AdoptionIndexSerializer < PictureUrlSerializer
  type 'pet'

  attributes :id, :name, :birthday, :avatar_url, :address, :distance, :pet_type_id

  def birthday
    object.birthday.to_i
  end

  def address
    object.user.location.try(:address)
  end

  def distance
    object.user.location.distance_to([scope[:latitude], scope[:longitude]], :km).try(:round, 2) if show_distance?
  end

  private

  def show_distance?
    scope[:latitude].present? && scope[:longitude].present? && object.user.location
  end
end
