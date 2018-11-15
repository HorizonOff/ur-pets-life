class CreateShoppingCartItems < ActiveRecord::Migration[5.1]
  def change
    create_table :shopping_cart_items do |t|
      t.boolean :IsRecurring
      t.integer :Interval
      t.integer :quantity
      t.references :item, foreign_key: true
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
