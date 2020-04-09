class AddDefaultsToOrderItems < ActiveRecord::Migration[5.2]
  def up
    change_column :order_items, :IsRecurring, :boolean, default: false
    change_column :order_items, :IsReviewed, :boolean, default: false
    change_column :order_items, :status, :order_item_status, default: :pending
    change_column :orders, :is_viewed, :boolean, default: false
    change_column :orders, :order_status_flag, :order_item_status, default: :pending
    change_column :orders, :admin_discount, :float
  end

  def down
    change_column :order_items, :IsRecurring, :boolean, default: nil
    change_column :order_items, :IsReviewed, :boolean, default: nil
    change_column :order_items, :status, :order_item_status, default: nil
    change_column :orders, :is_viewed, :boolean, default: nil
    change_column :orders, :order_status_flag, :order_item_status, default: nil
    change_column :orders, :admin_discount, :integer
  end
end
