class ChangeOrderItemStatusEnum3 < ActiveRecord::Migration[5.2]
  disable_ddl_transaction!

  def change
    execute "ALTER TYPE order_item_status ADD VALUE 'delivered_online' AFTER 'delivered_by_card'"
  end
end
