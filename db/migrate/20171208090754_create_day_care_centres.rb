class CreateDayCareCentres < ActiveRecord::Migration[5.1]
  def change
    create_table :day_care_centres do |t|
      t.references :clinic, foreign_key: true
      t.string :name
      t.string :email
      t.string :picture
      t.string :mobile_number
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
