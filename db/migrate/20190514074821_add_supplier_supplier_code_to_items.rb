class AddSupplierSupplierCodeToItems < ActiveRecord::Migration[5.1]
  def change
    add_column :items, :supplier, :string
    add_column :items, :supplier_code, :string
  end
end
