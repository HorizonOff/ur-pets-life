class AddPictureToItemBrand < ActiveRecord::Migration[5.1]
  def change
    add_column :item_brands, :picture, :string
  end
end
