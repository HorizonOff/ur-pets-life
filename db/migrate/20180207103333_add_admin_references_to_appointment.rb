class AddAdminReferencesToAppointment < ActiveRecord::Migration[5.1]
  def up
    add_reference :appointments, :admin, foreign_key: true
    Appointment.all.each do |a|
      a.update_column(:admin_id, a.bookable.admin_id)
    end
  end

  def down
    remove_reference :appointments, :admin
  end
end
