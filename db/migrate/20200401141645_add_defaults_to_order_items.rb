class AddDefaultsToOrderItems < ActiveRecord::Migration[5.2]
  def up
    change_column :order_items, :IsRecurring, :boolean, default: false
    change_column :order_items, :IsReviewed, :boolean, default: false
    change_column :order_items, :status, :order_item_status, default: :pending

  end

  def down
    change_column :order_items, :IsRecurring, :boolean, default: nil
    change_column :order_items, :IsReviewed, :boolean, default: nil
    change_column :order_items, :status, :order_item_status, default: nil
  end
end
