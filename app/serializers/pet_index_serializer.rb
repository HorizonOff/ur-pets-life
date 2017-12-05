class PetIndexSerializer < ActiveModel::Serializer
  type 'pet'

  attributes :id, :name, :birthday, :avatar

  def birthday
    object.birthday.utc.iso8601
  end

  def avatar
    object.avatar.try(:url)
  end
end
