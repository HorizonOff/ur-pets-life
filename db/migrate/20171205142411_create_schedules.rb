class CreateSchedules < ActiveRecord::Migration[5.1]
  def change
    create_table :schedules do |t|
      t.references :schedulable, polymorphic: true
      t.boolean :day_and_night, default: false
      t.time :monday_open_at
      t.time :monday_close_at
      t.time :tuesday_open_at
      t.time :tuesday_close_at
      t.time :wednesday_open_at
      t.time :wednesday_close_at
      t.time :thursday_open_at
      t.time :thursday_close_at
      t.time :friday_open_at
      t.time :friday_close_at
      t.time :saturday_open_at
      t.time :saturday_close_at
      t.time :sunday_open_at
      t.time :sunday_close_at

      t.timestamps
    end
  end
end
