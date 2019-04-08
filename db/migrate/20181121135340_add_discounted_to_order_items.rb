class AddDiscountedToOrderItems < ActiveRecord::Migration[5.1]
  def change
    add_column :order_items, :isdiscounted, :boolean
  end
end
