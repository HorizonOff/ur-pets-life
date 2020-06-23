class OrderItemSerializer < ActiveModel::Serializer
  attributes :id, :Quantity, :IsRecurring, :IsReviewed, :status

  has_one :order
  has_one :item
  belongs_to :recurssion_interval
  has_many :item_reviews
end
