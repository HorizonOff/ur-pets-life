class AddStatusToContactRequests < ActiveRecord::Migration[5.1]
  def change
    add_column :contact_requests, :is_answered, :boolean, default: false
  end
end
