class CreateTrainers < ActiveRecord::Migration[5.1]
  def change
    create_table :trainers do |t|
      t.string :name
      t.string :email
      t.string :picture
      t.string :mobile_number
      t.boolean :is_active
      t.integer :experience

      t.timestamps
    end

    create_join_table :specializations, :trainers
    create_join_table :pet_types, :trainers
  end
end
