class CreateItemReviews < ActiveRecord::Migration[5.1]
  def change
    create_table :item_reviews do |t|
      t.references :user, foreign_key: true
      t.references :item, foreign_key: true
      t.integer :rating
      t.string :comment

      t.timestamps
    end
  end
end
