class CreateQualifications < ActiveRecord::Migration[5.1]
  def change
    create_table :qualifications do |t|
      t.references :vet, foreign_key: true
      t.string :diploma
      t.string :university

      t.timestamps
    end
  end
end
