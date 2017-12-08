class CreateGroomingCentres < ActiveRecord::Migration[5.1]
  def change
    create_table :grooming_centres do |t|
      t.string :name
      t.string :email
      t.string :mobile_number
      t.string :picture
      t.string :website
      t.text :description
      t.boolean :is_active

      t.timestamps
    end

    create_join_table :grooming_centres, :pet_types
  end
end
