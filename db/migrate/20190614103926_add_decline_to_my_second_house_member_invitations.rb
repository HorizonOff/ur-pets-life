class AddDeclineToMySecondHouseMemberInvitations < ActiveRecord::Migration[5.1]
  def change
    add_column :my_second_house_member_invitations, :unsubscribe, :boolean, default: false
    add_column :my_second_house_member_invitations, :name, :string
    add_column :my_second_house_member_invitations, :token, :string
    add_index :my_second_house_member_invitations, :token, unique: true
  end
end
