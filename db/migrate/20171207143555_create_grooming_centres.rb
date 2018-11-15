class CreateGroomingCentres < ActiveRecord::Migration[5.1]
  def change
    create_table :grooming_centres do |t|
      t.references :admin, foreign_key: true
      t.string :name
      t.string :email
      t.string :mobile_number
      t.string :picture
      t.string :website
      t.text :description
      t.boolean :is_active, default: true

      t.timestamps

      t.index :name
      t.index :email
      t.index :mobile_number
      t.index :is_active
    end
  end
end
