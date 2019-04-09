class CreateRecurssionIntervals < ActiveRecord::Migration[5.1]
  def change
    create_table :recurssion_intervals do |t|
      t.integer :weeks
      t.integer :days

      t.timestamps
    end
  end
end
