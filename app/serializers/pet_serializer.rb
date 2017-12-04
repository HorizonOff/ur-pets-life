class PetSerializer < ActiveModel::Serializer
  attributes :id, :avatar, :name, :sex, :weight, :birthday, :comment
  belongs_to :breed
  has_many :vaccine_types
  has_many :pictures do
    object.pictures || []
  end

  def avatar
    object.avatar.try(:url)
  end

  def birthday
    object.birthday.utc.iso8601
  end
end
