class PetSerializer < ActiveModel::Serializer
  attributes :id, :name, :sex, :weight, :birthday, :comment
  belongs_to :breed
  has_many :vaccine_types

  def birthday
    object.birthday.utc.iso8601
  end

  class VaccineTypeSerializer < ActiveModel::Serializer
    attributes :id, :name

    has_many :vaccinations do
      scope[:pet_vaccinations][object.id] || []
    end
  end
end
