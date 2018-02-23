class CreateAdditionalServices < ActiveRecord::Migration[5.1]
  def change
    create_table :additional_services do |t|
      t.string :name
      t.string :email
      t.string :picture
      t.string :mobile_number
      t.string :website
      t.text :description
      t.boolean :is_active
      t.datetime :deleted_at

      t.timestamps

      t.index :name
      t.index :email
      t.index :is_active
      t.index :deleted_at
    end
  end
end
