class AddOrderItemReferenceToItemReview < ActiveRecord::Migration[5.1]
  def change
    add_reference :item_reviews, :order_item, foreign_key: true
  end
end
