class CreateLocations < ActiveRecord::Migration[5.1]
  def change
    create_table :locations do |t|
      t.references :place, polymorphic: true
      t.float :latitude
      t.float :longitude
      t.string :city
      t.string :area
      t.string :street
      t.integer :building_type
      t.string :building_name
      t.string :unit_number
      t.string :villa_number

      t.timestamps
    end
  end
end
