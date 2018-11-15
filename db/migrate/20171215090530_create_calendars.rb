class CreateCalendars < ActiveRecord::Migration[5.1]
  def change
    create_table :calendars do |t|
      t.references :vet, foreign_key: true
      t.datetime :start_at
      t.datetime :end_at

      t.timestamps

      t.index      :start_at
      t.index      :end_at
    end
  end
end
