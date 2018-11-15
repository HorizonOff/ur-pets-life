class PetTypeSerializer < ActiveModel::Serializer
  attributes :id, :name, :picture, :IsHaveCategories
end
