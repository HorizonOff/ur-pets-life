class AddMemberTypeToInvitaitons < ActiveRecord::Migration[5.1]
  def change
    add_column :my_second_house_member_invitations, :member_type, :integer, default: 1
  end
end
