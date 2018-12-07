module AdminPanel
class OrderSerializer < ActiveModel::Serializer
  attributes :id, :order_id, :item_id , :Quantity, :Total_Price, :IsRecurring, :status, :name, :picture, :created_at, :actions
end
end
