module AdminPanel
class ItemBrandSerializer < ActiveModel::Serializer
  attributes :id, :name, :picture, :brand_discount, :actions
end
end
