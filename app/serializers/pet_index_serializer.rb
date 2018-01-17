class PetIndexSerializer < PictureUrlSerializer
  type 'pet'

  attributes :id, :name, :birthday, :avatar_url, :pet_type_id

  def birthday
    object.birthday.to_i
  end
end
