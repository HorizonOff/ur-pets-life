module AdminPanel
  class SpecializationFilterSerializer < BaseMethodsSerializer
    attributes :id, :name, :actions
    attribute :for_trainer?, key: :is_for_trainer
  end
end
