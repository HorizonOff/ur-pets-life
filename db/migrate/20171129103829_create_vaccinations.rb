class CreateVaccinations < ActiveRecord::Migration[5.1]
  def change
    create_table :vaccinations do |t|
      t.references :vaccine_type, foreign_key: true
      t.references :pet, foreign_key: true
      t.datetime :done_at

      t.timestamps
    end
  end
end
