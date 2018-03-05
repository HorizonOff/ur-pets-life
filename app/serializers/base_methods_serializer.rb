class BaseMethodsSerializer < ActiveModel::Serializer
  def avatar_url
    object.avatar.try(:url)
  end

  def remove_avatar
    false
  end

  def picture_url
    object.picture.try(:url)
  end

  def remove_picture
    false
  end

  def favorite_id
    scope[:favorite].try(:id)
  end

  def birthday
    object.birthday.to_i if object.birthday
  end

  def show_service_options?
    scope[:pets_services].blank?
  end

  def distance
    object.location.distance_to([scope[:latitude], scope[:longitude]], :km).try(:round, 2) if show_distance?
  end

  def type
    object.class.to_s
  end

  def created_at
    object.created_at.to_i
  end

  private

  def show_distance?
    object.location.present? && scope[:latitude].present? && scope[:longitude].present?
  end

  def show_user_distance?
    object.user_location && scope[:latitude].present? && scope[:longitude].present?
  end
end
