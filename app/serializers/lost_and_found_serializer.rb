class LostAndFoundSerializer < PictureUrlSerializer
  type 'pet'

  attributes :id, :name, :avatar_url, :address, :distance, :lost_at, :found_at, :comment

  has_many :pictures do
    object.pictures || []
  end

  def birthday
    object.birthday.utc.iso8601
  end

  def address
    object.location.try(:address)
  end

  def distance
    object.location.distance_to([scope[:latitude], scope[:longitude]], :km).try(:round, 2) if show_distance?
  end

  def lost_at
    object.lost_at.utc.iso8601 if object.lost_at.present?
  end

  def found_at
    object.found_at.utc.iso8601 if object.found_at.present?
  end

  private

  def show_distance?
    scope[:latitude].present? && scope[:longitude].present?
  end
end
