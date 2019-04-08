class ShoppingCartItemSerializer < ActiveModel::Serializer
  attributes :id, :IsRecurring, :Interval, :quantity
  has_one :item
  has_one :user
end
