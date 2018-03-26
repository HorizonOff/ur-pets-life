class CreateBlockedTimes < ActiveRecord::Migration[5.1]
  def change
    create_table :blocked_times do |t|
      t.references :blockable, polymorphic: true
      t.datetime :start_at
      t.datetime :end_at

      t.timestamps

      t.index      :start_at
      t.index      :end_at
    end
  end
end
