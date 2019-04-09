class ShoppingCartItem < ApplicationRecord
  belongs_to :item
  belongs_to :user
  belongs_to :recurssion_interval, optional: true
end
