class CreateDiagnoses < ActiveRecord::Migration[5.1]
  def change
    create_table :diagnoses do |t|
      t.references :appointment, foreign_key: true
      t.text :message
      t.string :condition

      t.timestamps
    end
  end
end
