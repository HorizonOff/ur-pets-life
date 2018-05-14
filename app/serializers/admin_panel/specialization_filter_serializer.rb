module AdminPanel
  class SpecializationFilterSerializer < BaseMethodsSerializer
    attributes :id, :name, :is_for_trainer, :actions
  end
end
