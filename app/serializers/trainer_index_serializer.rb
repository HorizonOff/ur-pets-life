class TrainerIndexSerializer < PictureUrlSerializer
  attributes :id, :name, :picture_url, :address, :distance

  def distance
    object.location.distance_to([scope[:latitude], scope[:longitude]], :km).try(:round, 2) if show_distance?
  end

  private

  def show_distance?
    scope[:latitude].present? && scope[:longitude].present?
  end
end
