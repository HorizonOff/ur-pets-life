class AddStatusToOrderItems < ActiveRecord::Migration[5.1]
  def change
    execute <<-SQL
  CREATE TYPE order_item_status AS ENUM ('pending', 'confirmed', 'on_the_way', 'delivered', 'cancelled');
    SQL
    add_column :order_items, :status, :order_item_status
  end
end
