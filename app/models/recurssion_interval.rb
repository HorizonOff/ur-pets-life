class RecurssionInterval < ApplicationRecord
  has_many :shopping_cart_items
  has_many :order_items
end
