module AdminPanel
class ItemCategorySerializer < ActiveModel::Serializer
  attributes :id, :name, :picture, :IsHaveBrand, :actions
end
end
