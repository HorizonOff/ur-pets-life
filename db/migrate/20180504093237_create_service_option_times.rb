class CreateServiceOptionTimes < ActiveRecord::Migration[5.1]
  def change
    create_table :service_option_times do |t|
      t.references :service_option_detail, foreign_key: true
      t.datetime :start_at
      t.datetime :end_at
      t.datetime :deleted_at

      t.timestamps
    end

    add_reference :cart_items, :service_option_detail, foreign_key: true
  end
end
