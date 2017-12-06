class CreateClinics < ActiveRecord::Migration[5.1]
  def change
    create_table :clinics do |t|
      t.string :name
      t.string :email
      t.string :picture
      t.string :mobile_number
      t.float :consultation_fee
      t.string :website
      t.text :description
      t.boolean :is_active
      t.boolean :is_emergency

      t.timestamps
    end
  end
end
