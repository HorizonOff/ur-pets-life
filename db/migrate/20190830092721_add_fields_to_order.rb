class AddFieldsToOrder < ActiveRecord::Migration[5.1]
  def change
    add_column :orders, :client_name, :string
    add_column :orders, :client_number, :string
    add_column :orders, :admin_discount, :integer
  end
end
