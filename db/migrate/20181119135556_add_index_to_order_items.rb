class AddIndexToOrderItems < ActiveRecord::Migration[5.1]
  def change
    add_index :order_items, :status
  end
end
