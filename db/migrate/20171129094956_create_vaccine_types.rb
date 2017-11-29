class CreateVaccineTypes < ActiveRecord::Migration[5.1]
  def change
    create_table :vaccine_types do |t|
      t.string :name
      t.text :pet_categories, array:true, default: []

      t.timestamps
    end
  end
end
