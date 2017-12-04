class CreatePictures < ActiveRecord::Migration[5.1]
  def change
    create_table :pictures do |t|
      t.references :pet, foreign_key: true
      t.string :attachment

      t.timestamps
    end
  end
end
