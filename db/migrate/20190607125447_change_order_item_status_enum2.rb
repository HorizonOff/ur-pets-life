class ChangeOrderItemStatusEnum2 < ActiveRecord::Migration[5.1]
  disable_ddl_transaction!

  def change
    execute "ALTER TYPE order_item_status ADD VALUE 'delivered_by_cash' AFTER 'delivered'"
  end
end
