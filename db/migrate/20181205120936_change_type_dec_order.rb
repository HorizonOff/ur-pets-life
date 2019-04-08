class ChangeTypeDecOrder < ActiveRecord::Migration[5.1]
  def change
    change_column :orders, :Subtotal, :float
    change_column :orders, :Delivery_Charges, :float
    change_column :orders, :Vat_Charges, :float
    change_column :orders, :Total, :float
  end
end
