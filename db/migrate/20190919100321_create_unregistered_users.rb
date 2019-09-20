class CreateUnregisteredUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :unregistered_users do |t|
      t.string :name
      t.string :number

      t.timestamps
    end
  end
end
