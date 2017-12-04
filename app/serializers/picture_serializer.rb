class PictureSerializer < ActiveModel::Serializer
  attributes :id, :attachment
  def attachment
    object.attachment.try(:url)
  end
end
