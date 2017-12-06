class CreateVets < ActiveRecord::Migration[5.1]
  def change
    create_table :vets do |t|
      t.references :clinic, foreign_key: true
      t.string :name
      t.string :email
      t.string :mobile_number
      t.string :avatar
      t.boolean :is_active, default: false
      t.boolean :is_emergency, default: false
      t.float :consultation_fee
      t.integer :experience

      t.timestamps
    end
  end
end
