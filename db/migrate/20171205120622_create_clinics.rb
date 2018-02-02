class CreateClinics < ActiveRecord::Migration[5.1]
  def change
    create_table :clinics do |t|
      t.references :admin, foreign_key: true
      t.string :name
      t.string :email
      t.string :picture
      t.string :mobile_number
      t.integer :consultation_fee
      t.string :website
      t.text :description
      t.boolean :is_active, default: true
      t.boolean :is_emergency, default: false
      t.integer :vets_count, default: 0

      t.timestamps

      t.index :name
      t.index :email
      t.index :mobile_number
      t.index :is_active
      t.index :is_emergency
      t.index :vets_count
    end
  end
end
