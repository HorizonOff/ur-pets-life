class AddFieldsToAppointments < ActiveRecord::Migration[5.1]
  def change
    add_column :appointments, :number_of_days, :integer, default: 1
    add_column :cart_items, :quantity, :integer, default: 1
    add_column :cart_items, :total_price, :integer
  end
end
