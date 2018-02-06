module AdminPanel
  class VetFilterSerializer < BaseMethodsSerializer
    attributes :id, :name, :avatar, :email, :mobile_number, :experience, :actions
    attribute :status, key: :is_active
  end
end
