class CreateBreeds < ActiveRecord::Migration[5.1]
  def change
    create_table :breeds do |t|
      t.string :name
      t.references :pet_type, foreign_key: true

      t.timestamps
    end
  end
end
