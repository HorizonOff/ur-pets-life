class CreateContactRequests < ActiveRecord::Migration[5.1]
  def change
    create_table :contact_requests do |t|
      t.references :user, foreign_key: true
      t.string :email
      t.string :subject
      t.string :message
      t.boolean :is_answered, default: false

      t.timestamps

      t.index :email
      t.index :is_answered
    end
  end
end
