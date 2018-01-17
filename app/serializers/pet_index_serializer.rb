class PetIndexSerializer < BaseMethodsSerializer
  type 'pet'

  attributes :id, :name, :birthday, :avatar_url, :pet_type_id
end
