module AdminPanel
  class TrainerFilterSerializer < BaseMethodsSerializer
    attributes :id, :name, :picture, :email, :mobile_number, :experience, :actions
    attribute :status, key: :is_active
  end
end
