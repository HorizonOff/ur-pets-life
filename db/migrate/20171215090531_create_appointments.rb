class CreateAppointments < ActiveRecord::Migration[5.1]
  def change
    create_table :appointments do |t|
      t.references :admin, foreign_key: true
      t.references :user, foreign_key: true
      t.references :bookable, polymorphic: true
      t.references :vet, foreign_key: true
      t.references :calendar, foreign_key: true
      t.integer :main_appointment_id
      t.string :comment
      t.datetime :start_at
      t.datetime :end_at
      t.integer :status
      t.integer :total_price
      t.timestamps

      t.index :main_appointment_id
      t.index :start_at
      t.index :end_at
      t.index :status
      t.index :total_price
      t.index :created_at
    end
  end
end
