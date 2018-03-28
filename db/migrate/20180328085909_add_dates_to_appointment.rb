class AddDatesToAppointment < ActiveRecord::Migration[5.1]
  def change
    add_column :appointments, :dates, :text, array:true, default: []
  end
end
