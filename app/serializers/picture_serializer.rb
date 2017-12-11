class PictureSerializer < ActiveModel::Serializer
  attributes :id, :attachment_url

  def picture_url
    object.attachment.try(:url)
  end
end
