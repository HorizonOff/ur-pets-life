class AddUnitPriceToItem < ActiveRecord::Migration[5.1]
  def change
    add_column :items, :unit_price, :integer
  end
end
