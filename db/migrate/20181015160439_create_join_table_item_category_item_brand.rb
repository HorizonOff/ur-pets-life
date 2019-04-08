class CreateJoinTableItemCategoryItemBrand < ActiveRecord::Migration[5.1]
  def change
    create_join_table :item_categories, :item_brands do |t|
      # t.index [:item_category_id, :item_brand_id]
      # t.index [:item_brand_id, :item_category_id]
    end
  end
end
