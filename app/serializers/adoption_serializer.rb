class AdoptionSerializer < BaseMethodsSerializer
  type 'pet'

  attributes :id, :avatar_url, :name, :sex, :weight, :birthday, :comment, :pet_type_id,
             :mobile_number, :address, :distance

  belongs_to :breed, unless: -> { object.pet_type_is_additional? }
  attribute :additional_type, if: -> { object.pet_type_is_additional? }
  has_many :vaccine_types
  has_many :pictures do
    object.pictures || []
  end

  def mobile_number
    object.user.mobile_number
  end

  def address
    object.user.location.try(:address)
  end

  def distance
    object.location.distance_to([scope[:latitude], scope[:longitude]], :km).try(:round, 2) if show_user_distance?
  end

  def sex
    Pet.sexes[object.sex]
  end

  class VaccineTypeSerializer < ActiveModel::Serializer
    attributes :id, :name

    has_many :vaccinations do
      scope[:pet_vaccinations][object.id] || []
    end
  end
end
