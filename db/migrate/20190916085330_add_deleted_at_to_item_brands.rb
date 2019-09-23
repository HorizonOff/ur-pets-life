class AddDeletedAtToItemBrands < ActiveRecord::Migration[5.1]
  def change
    add_column :item_brands, :deleted_at, :datetime
  end
end
