class AddCodeDiscountToOrders < ActiveRecord::Migration[5.1]
  def change
    add_column :orders, :code_discount, :integer, default: 0
  end
end
