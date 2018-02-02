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

      t.datetime :lost_at
      t.datetime :found_at
      t.boolean :is_for_adoption, default: false

      t.string :description
      t.string :mobile_number
      t.string :additional_comment

      t.timestamps

      t.index :lost_at
      t.index :found_at
      t.index :is_for_adoption
    end
  end
end
