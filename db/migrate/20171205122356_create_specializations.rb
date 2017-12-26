class CreateSpecializations < ActiveRecord::Migration[5.1]
  def change
    create_table :specializations do |t|
      t.string :name
      t.boolean :is_for_trainer, default: false

      t.timestamps
    end
  end
end
