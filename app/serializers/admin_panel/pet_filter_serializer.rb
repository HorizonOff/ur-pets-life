module AdminPanel
  class PetFilterSerializer < ActiveModel::Serializer
    attributes :id, :name, :avatar, :birthday, :status, :weight, :actions
    attribute :pet_type, key: :pet_type_id
    attribute :gender, key: :sex
  end
end
