module AdminPanel
  class UserFilterSerializer < BaseMethodsSerializer
    attributes :id, :name, :email, :mobile_number, :actions
    attribute :status, key: :is_active
  end
end
