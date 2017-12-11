class PictureSerializer < ActiveModel::Serializer
  attributes :id, :attachment_url

  def attachment_url
    object.attachment.try(:url)
  end
end
