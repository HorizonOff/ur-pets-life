class MySecondHouseMemberInvitation < ApplicationRecord
  enum member_type: { simple: 1, silver: 2, gold: 3 }

  after_commit :send_invitation, :set_token, on: :create

  def self.import(file)
    spreadsheet = Roo::Spreadsheet.open(file.path)
    header = spreadsheet.row(1)
    (2..spreadsheet.last_row).each do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]
      create(name: row.first[1], email: row["Email Address"], member_type: row["Type"])
    end
  end

  private

  def send_invitation
    # InvitationWorker.perform_async(id)
    InvitationMailer.invite_my_second_house_member(id).deliver
  end

  def set_token
    update_column(:token, SecureRandom.hex(10))
  end
end
