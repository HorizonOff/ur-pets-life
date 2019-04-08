class AddItemBrandToItems < ActiveRecord::Migration[5.1]
  def change
    add_reference :items, :item_brands, foreign_key: true
  end
end
