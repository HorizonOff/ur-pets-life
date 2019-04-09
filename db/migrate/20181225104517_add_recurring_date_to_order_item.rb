class AddRecurringDateToOrderItem < ActiveRecord::Migration[5.1]
  def change
    add_column :order_items, :next_recurring_due_date, :datetime
  end
end
