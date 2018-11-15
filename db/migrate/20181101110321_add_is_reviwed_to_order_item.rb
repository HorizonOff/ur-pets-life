class AddIsReviwedToOrderItem < ActiveRecord::Migration[5.1]
  def change
    add_column :order_items, :IsReviewed, :boolean
  end
end
