class OrderItem < ApplicationRecord
  attr_accessor :updated_status
  belongs_to :order
  belongs_to :item, -> { with_deleted }
  has_many :item_reviews
  belongs_to :recurssion_interval, optional: true
  enum status: { pending: "pending", confirmed: "confirmed", on_the_way: "on_the_way", delivered: "delivered",
                 delivered_by_card: "delivered_by_card", delivered_by_cash: "delivered_by_cash",
                 delivered_online: "delivered_online", cancelled: "cancelled" }, _prefix: :status
end
