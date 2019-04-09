class AddColumnToItemBrand < ActiveRecord::Migration[5.1]
  def change
    add_column :item_brands, :brand_discount, :float
  end
end
