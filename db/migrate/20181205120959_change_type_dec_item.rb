class ChangeTypeDecItem < ActiveRecord::Migration[5.1]
  def change
    change_column :items, :price, :float
    change_column :items, :unit_price, :float
    change_column :items, :buying_price, :float
    change_column :items, :discount, :float
  end
end
