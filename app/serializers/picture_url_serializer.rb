class PictureUrlSerializer < ActiveModel::Serializer
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
end
