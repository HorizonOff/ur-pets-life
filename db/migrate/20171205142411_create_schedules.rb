class CreateSchedules < ActiveRecord::Migration[5.1]
  def change
    create_table :schedules do |t|
      t.references :schedulable, polymorphic: true
      t.time :monday_start_at
      t.time :monday_end_at
      t.time :tuesday_start_at
      t.time :tuesday_end_at
      t.time :wednesday_start_at
      t.time :wednesday_end_at
      t.time :thursday_start_at
      t.time :thursday_end_at
      t.time :friday_start_at
      t.time :friday_end_at
      t.time :saturday_start_at
      t.time :saturday_end_at
      t.time :sunday_start_at
      t.time :sunday_end_at

      t.timestamps
    end
  end
end
