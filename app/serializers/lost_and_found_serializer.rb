class LostAndFoundSerializer < PictureUrlSerializer
  type 'pet'

  attributes :id, :description, :avatar_url, :address, :distance, :lost_at, :found_at, :additional_comment,
             :mobile_number

  def birthday
    object.birthday.to_i
  end

  def distance
    object.location.distance_to([scope[:latitude], scope[:longitude]], :km).try(:round, 2) if show_distance?
  end

  def lost_at
    object.lost_at.to_i if object.lost_at.present?
  end

  def found_at
    object.found_at.to_i if object.found_at.present?
  end

  private

  def show_distance?
    scope[:latitude].present? && scope[:longitude].present?
  end
end
