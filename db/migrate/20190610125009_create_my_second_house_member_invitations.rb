class CreateMySecondHouseMemberInvitations < ActiveRecord::Migration[5.1]
  def change
    create_table :my_second_house_member_invitations do |t|
      t.string :email

      t.timestamps
    end
  end
end
