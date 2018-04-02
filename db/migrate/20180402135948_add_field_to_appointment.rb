class AddFieldToAppointment < ActiveRecord::Migration[5.1]
  def change
    add_column :appointments, :is_viewed, :boolean, default: false
  end
end
