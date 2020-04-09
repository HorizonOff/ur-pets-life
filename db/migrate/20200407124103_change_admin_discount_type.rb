class ChangeAdminDiscountType < ActiveRecord::Migration[5.2]
  def change
    change_column :orders, :admin_discount, :float
  end
end
