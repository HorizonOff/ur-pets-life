class DeleteJoinTableItemItemBrand < ActiveRecord::Migration[5.1]
  def change
    drop_join_table :items, :item_brands
  end
end
