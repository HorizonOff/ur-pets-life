class AdoptionIndexSerializer < PictureUrlSerializer
  type 'pet'

  attributes :id, :name, :birthday, :avatar_url, :address, :distance, :pet_type_id

  def birthday
    object.birthday.utc.iso8601
  end

  def address
    object.location.try(:address)
  end

  def distance
    object.location.distance_to([scope[:latitude], scope[:longitude]], :km).try(:round, 2) if show_distance?
  end

  private

  def show_distance?
    scope[:latitude].present? && scope[:longitude].present?
  end
end
