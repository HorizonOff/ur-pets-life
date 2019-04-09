class AddOrderCounterToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :commented_orders_count, :integer, null: false, default: 0
    add_column :users, :unread_commented_orders_count, :integer, null: false, default: 0
    add_column :admins, :unread_commented_orders_count, :integer, null: false, default: 0
  end
end
