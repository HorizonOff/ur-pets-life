class CreateSpecializations < ActiveRecord::Migration[5.1]
  def change
    create_table :specializations do |t|
      t.string :name
      t.boolean :is_for_trainer, default: false

      t.timestamps

      t.index :is_for_trainer
    end
  end
end
