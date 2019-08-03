module AdminPanel
  class UserFilterSerializer < ActiveModel::Serializer
    attributes :id, :name, :email, :mobile_number, :last_action_at, :created_at, :actions
    attribute :status, key: :is_active
  end
end
