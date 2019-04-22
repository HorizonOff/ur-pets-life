class UserShoppingCartSerializer < ActiveModel::Serializer
  attributes :id, :IsRecurring, :Interval, :quantity
  has_one :item
  has_one :recurssion_interval
end
