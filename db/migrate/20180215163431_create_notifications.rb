class CreateNotifications < ActiveRecord::Migration[5.1]
  def change
    create_table :notifications do |t|
      t.references :admin, foreign_key: true
      t.references :user, foreign_key: true
      t.references :appointment, foreign_key: true
      t.references :pet, foreign_key: true
      t.string     :message
      t.boolean    :skip_push_sending, default: false

      t.timestamps
    end

    add_column :users, :notifications_count, :integer, default: 0
  end
end
