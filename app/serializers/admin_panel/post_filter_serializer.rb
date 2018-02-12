module AdminPanel
  class PostFilterSerializer < ActiveModel::Serializer
    attributes :id, :title, :actions, :created_at
    attribute :pet_type_name, key: :pet_type_id
    attribute :user_name, key: :name
  end
end
