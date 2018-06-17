class AddCountersToModels < ActiveRecord::Migration[5.1]
  def up
    add_column :comments,     :read_at, :datetime

    add_column :users,        :commented_appointments_count, :integer, null: false, default: 0
    add_column :users,        :unread_commented_appointments_count, :integer, null: false, default: 0
    add_column :admins,       :unread_commented_appointments_count, :integer, null: false, default: 0
    add_column :appointments, :unread_comments_count_by_user, :integer, null: false, default: 0
    add_column :appointments, :unread_comments_count_by_admin, :integer, null: false, default: 0

    add_index :comments,     :read_at
    add_index :users,        :unread_commented_appointments_count
    add_index :admins,       :unread_commented_appointments_count
    add_index :appointments, :unread_comments_count_by_user
    add_index :appointments, :unread_comments_count_by_admin

    Comment.update_all(read_at: Time.current)
    Appointment.all.each { |a| a.update_counters}
    User.all.each { |u| u.update_counters }
    Admin.all.each { |a| a.update_counters }
  end

  def down
    remove_column :comments,     :read_at, :datetime

    remove_column :users,        :commented_appointments_count, :integer
    remove_column :users,        :unread_commented_appointments_count, :integer
    remove_column :admins,       :unread_commented_appointments_count, :integer
    remove_column :appointments, :unread_comments_count_by_user, :integer
    remove_column :appointments, :unread_comments_count_by_admin, :integer
  end
end
