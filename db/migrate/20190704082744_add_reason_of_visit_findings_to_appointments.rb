class AddReasonOfVisitFindingsToAppointments < ActiveRecord::Migration[5.1]
  def change
    add_column :appointments, :reason_of_visit, :string
    add_column :appointments, :findings, :string
  end
end
