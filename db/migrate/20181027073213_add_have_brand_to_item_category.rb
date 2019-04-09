class AddHaveBrandToItemCategory < ActiveRecord::Migration[5.1]
  def change
    add_column :item_categories, :IsHaveBrand, :boolean
  end
end
