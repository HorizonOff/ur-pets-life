class AddStatusColumnToOrder < ActiveRecord::Migration[5.1]
  def change
    add_column :orders, :order_status_flag, :order_item_status
  end
end
