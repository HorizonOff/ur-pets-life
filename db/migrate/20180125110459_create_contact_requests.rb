class CreateContactRequests < ActiveRecord::Migration[5.1]
  def change
    create_table :contact_requests do |t|
      t.references :user, foreign_key: true
      t.string :subject
      t.string :message

      t.timestamps
    end
  end
end
