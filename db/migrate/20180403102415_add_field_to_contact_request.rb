class AddFieldToContactRequest < ActiveRecord::Migration[5.1]
  def change
    add_column :contact_requests, :is_viewed, :boolean, default: false
  end
end
