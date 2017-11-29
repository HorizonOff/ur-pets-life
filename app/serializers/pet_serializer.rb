class PetSerializer < ActiveModel::Serializer
  type 'pet'

  attributes :name, :sex, :weight, :birthday, :comment
  belongs_to :breed
  has_many :vaccinations, key: :vaccinations_attributes

  def birthday
    object.birthday.utc.iso8601
  end
end
