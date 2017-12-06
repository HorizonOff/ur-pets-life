class PetIndexSerializer < ActiveModel::Serializer
  type 'pet'

  attributes :id, :name, :birthday, :avatar

  def birthday
    object.birthday.utc.iso8601
  end
end
