class Order < ApplicationRecord
  belongs_to :user
  belongs_to :location
  has_many :order_items
  has_many :notifications
  enum order_status_flag: { pending: "pending", confirmed: "confirmed", on_the_way: "on_the_way", delivered: "delivered", cancelled: "cancelled" }, _prefix: :order_status_flag
end
