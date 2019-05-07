class ItemReview < ApplicationRecord
  belongs_to :user
  belongs_to :item, -> { with_deleted }
  belongs_to :order_item
end
