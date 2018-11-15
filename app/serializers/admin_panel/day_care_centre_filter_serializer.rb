module AdminPanel
  class DayCareCentreFilterSerializer < BaseMethodsSerializer
    attributes :id, :name, :picture, :email, :mobile_number, :actions
    attribute :status, key: :is_active
  end
end
