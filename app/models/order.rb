class Order < ApplicationRecord
  belongs_to :user
  belongs_to :location
  has_many :order_items
end
