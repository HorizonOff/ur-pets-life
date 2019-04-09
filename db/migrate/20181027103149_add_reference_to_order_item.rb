class AddReferenceToOrderItem < ActiveRecord::Migration[5.1]
  def change
    add_reference :order_items, :recurssion_intervals, foreign_key: true
  end
end
