class CreateCartItems < ActiveRecord::Migration[5.1]
  def change
    create_table :cart_items do |t|
      t.references :appointment, foreign_key: true
      t.references :service_detail, foreign_key: true
      t.integer :price

      t.timestamps
    end
  end
end
