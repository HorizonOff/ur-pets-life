class AddDeliveryAtToOrders < ActiveRecord::Migration[5.1]
  def change
    add_column :orders, :delivery_at, :datetime
  end
end
