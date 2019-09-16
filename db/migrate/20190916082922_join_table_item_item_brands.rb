class JoinTableItemItemBrands < ActiveRecord::Migration[5.1]
  def change
    create_join_table :items, :item_brands do |t|
      # t.index [:item_id, :item_brands_id]
    end
  end
end
