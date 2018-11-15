class AddFieldsToContactRequest < ActiveRecord::Migration[5.1]
  def change
    add_column :contact_requests, :user_name, :string
  end
end
