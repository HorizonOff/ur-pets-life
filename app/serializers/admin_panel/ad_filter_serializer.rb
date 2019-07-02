module AdminPanel
  class AdFilterSerializer < ActiveModel::Serializer
    attributes :id, :name, :image, :view_count, :is_active, :actions
  end
end
