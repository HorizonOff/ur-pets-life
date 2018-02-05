module AdminPanel
  class AdminFilterSerializer < BaseMethodsSerializer
    attributes :id, :name, :avatar, :email, :actions
    attribute :status, key: :is_active
    attribute :super_admin_status, key: :is_super_admin
  end
end
