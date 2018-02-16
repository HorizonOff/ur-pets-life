class CreateNotifications < ActiveRecord::Migration[5.1]
  def change
    create_table :notifications do |t|
      t.references :user, foreign_key: true
      t.references :appointment, foreign_key: true
      t.references :pet, foreign_key: true
      t.string :message

      t.timestamps
    end
  end
end
