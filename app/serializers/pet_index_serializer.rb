class PetIndexSerializer < BaseMethodsSerializer
  type 'pet'

  attributes :id, :name, :birthday, :avatar_url, :pet_type_id, :mobile_number

  def mobile_number
    object.mobile_number || object.user.mobile_number
  end
end
