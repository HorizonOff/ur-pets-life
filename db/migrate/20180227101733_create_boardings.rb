class CreateBoardings < ActiveRecord::Migration[5.1]
  def change
    create_table :boardings do |t|
      t.references :admin, foreign_key: true
      t.string :name
      t.string :email
      t.string :picture
      t.string :mobile_number
      t.string :website
      t.text :description
      t.boolean :is_active, default: true
      t.datetime :deleted_at

      t.timestamps

      t.index :name
      t.index :email
      t.index :mobile_number
      t.index :is_active
      t.index :deleted_at
    end

    create_join_table :boardings, :service_options
  end
end
