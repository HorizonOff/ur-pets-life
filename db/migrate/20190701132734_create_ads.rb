class CreateAds < ActiveRecord::Migration[5.1]
  def change
    create_table :ads do |t|
      t.string :name
      t.string :image
      t.boolean :is_active, default: false
      t.integer :view_count, default: 0

      t.timestamps
    end
  end
end
