class CreateAddresses < ActiveRecord::Migration[5.1]
  def change
    create_table :addresses do |t|
      t.references :user, foreign_key: true
      t.float :latitude
      t.float :longitude
      t.string :country
      t.string :city
      t.string :street
      t.integer :building_type
      t.string :building_name
      t.string :unit_number
      t.string :villa_number

      t.timestamps
    end
  end
end
