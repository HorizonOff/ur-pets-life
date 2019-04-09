class AddPriceColumnToItem < ActiveRecord::Migration[5.1]
  def change
    add_column :items, :buying_price, :integer
  end
end
