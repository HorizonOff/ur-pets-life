class AddColumnsToOrderItems < ActiveRecord::Migration[5.1]
  def change
    add_column :order_items, :IsRecurring, :boolean
    add_column :order_items, :Interval, :integer
  end
end
