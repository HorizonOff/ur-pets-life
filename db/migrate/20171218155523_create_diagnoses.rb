class CreateDiagnoses < ActiveRecord::Migration[5.1]
  def change
    create_table :diagnoses do |t|
      t.references :appointment, foreign_key: true
      t.text :message
      t.string :condition
      t.integer :next_appointment_id

      t.timestamps
    end
  end
end
