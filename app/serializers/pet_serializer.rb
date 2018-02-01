class PetSerializer < BaseMethodsSerializer
  type 'pet'

  attributes :id, :avatar_url, :name, :sex, :weight, :birthday, :comment, :pet_type_id,
             :lost_at, :is_for_adoption

  belongs_to :breed, unless: -> { object.pet_type_is_additional? }
  attribute :additional_type, if: -> { object.pet_type_is_additional? }
  has_many :vaccine_types
  has_many :pictures do
    object.pictures || []
  end

  def sex
    Pet.sexes[object.sex]
  end

  def lost_at
    object.lost_at.to_i if object.lost_at.present?
  end

  class VaccineTypeSerializer < ActiveModel::Serializer
    attributes :id, :name

    has_many :vaccinations do
      scope[:pet_vaccinations][object.id] || []
    end
  end
end
