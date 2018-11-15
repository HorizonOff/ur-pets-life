class OrderItemSerializer < ActiveModel::Serializer
  attributes :id, :Quantity, :Unit_Price, :Total_Price
  has_one :order
  has_one :item
end
