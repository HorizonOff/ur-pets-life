class PictureSerializer < ActiveModel::Serializer
  attributes :id, :picture_url

  def picture_url
    object.attachment.try(:url)
  end
end
