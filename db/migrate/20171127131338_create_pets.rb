class CreatePets < ActiveRecord::Migration[5.1]
  def change
    create_table :pets do |t|
      t.references :user, foreign_key: true
      t.references :breed, foreign_key: true
      t.references :pet_type, foreign_key: true
      t.string :additional_type
      t.string :name
      t.datetime :birthday
      t.integer :sex
      t.float :weight
      t.string :comment
      t.string :avatar
      t.boolean :is_lost, default: false
      t.boolean :is_for_adoption, default: false

      t.timestamps
    end
  end
end
