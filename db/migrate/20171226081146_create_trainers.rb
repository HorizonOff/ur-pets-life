class CreateTrainers < ActiveRecord::Migration[5.1]
  def change
    create_table :trainers do |t|
      t.string :name
      t.string :email
      t.string :picture
      t.string :mobile_number
      t.boolean :is_active, default: true
      t.integer :experience

      t.timestamps

      t.index :name
      t.index :email
      t.index :mobile_number
      t.index :is_active
      t.index :experience
    end

    create_join_table :specializations, :trainers
    create_join_table :pet_types, :trainers
  end
end
