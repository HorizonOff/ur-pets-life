class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :item
  has_many :item_reviews
  belongs_to :recurssion_interval, optional: true
end
