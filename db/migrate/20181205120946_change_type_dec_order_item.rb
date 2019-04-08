class ChangeTypeDecOrderItem < ActiveRecord::Migration[5.1]
  def change
    change_column :order_items, :Unit_Price, :float
    change_column :order_items, :Total_Price, :float
  end
end
