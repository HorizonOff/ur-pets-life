class CreateVaccineTypes < ActiveRecord::Migration[5.1]
  def change
    create_table :vaccine_types do |t|
      t.string :name

      t.timestamps
    end

    create_join_table :pet_types, :vaccine_types
  end
end
