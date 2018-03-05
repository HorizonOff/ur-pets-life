class CreateCartItems < ActiveRecord::Migration[5.1]
  def change
    create_table :cart_items do |t|
      t.references :pet, foreign_key: true
      t.references :appointment, foreign_key: true
      t.references :serviceable, polymorphic: true
      t.integer :price

      t.timestamps
    end
  end
end
