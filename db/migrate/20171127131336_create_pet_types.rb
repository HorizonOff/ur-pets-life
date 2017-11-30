class CreatePetTypes < ActiveRecord::Migration[5.1]
  def change
    create_table :pet_types do |t|
      t.string :name
      t.boolean :is_additional_type, default: false

      t.timestamps
    end
  end
end
