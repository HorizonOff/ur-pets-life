class CreateMedications < ActiveRecord::Migration[5.1]
  def change
    create_table :medications do |t|
      t.references :appointment
      t.string :name

      t.timestamps
    end
  end
end
