module AdminPanel
class PettypeSerializer < ActiveModel::Serializer
  attributes :id, :name, :picture, :IsHaveCategories
end
end
