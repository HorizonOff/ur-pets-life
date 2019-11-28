class AddDefaultToOrderPaymentStatus < ActiveRecord::Migration[5.2]
  def change
    change_column :orders, :Payment_Status, :integer, default: 0
  end
end
