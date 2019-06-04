class AddPrerecurringToOrders < ActiveRecord::Migration[5.1]
  def change
    add_column :orders, :is_pre_recurring, :boolean, default: false
  end
end
