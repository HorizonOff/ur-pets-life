class CreateSchedules < ActiveRecord::Migration[5.1]
  def change
    create_table :schedules do |t|
      t.references :schedulable, polymorphic: true
      t.boolean :day_and_night, default: false
      t.datetime :monday_open_at
      t.datetime :monday_close_at
      t.datetime :tuesday_open_at
      t.datetime :tuesday_close_at
      t.datetime :wednesday_open_at
      t.datetime :wednesday_close_at
      t.datetime :thursday_open_at
      t.datetime :thursday_close_at
      t.datetime :friday_open_at
      t.datetime :friday_close_at
      t.datetime :saturday_open_at
      t.datetime :saturday_close_at
      t.datetime :sunday_open_at
      t.datetime :sunday_close_at

      t.timestamps
    end
  end
end
