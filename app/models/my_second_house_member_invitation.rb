class MySecondHouseMemberInvitation < ApplicationRecord
  after_commit :send_invitation, on: :create

  def self.import(file)
    spreadsheet = Roo::Spreadsheet.open(file.path)
    header = spreadsheet.row(1)
    (2..spreadsheet.last_row).each do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]
      create(email: row["Email Address"])
    end
  end

  private

  def send_invitation
    # InvitationWorker.perform_async(id)
    InvitationMailer.invite_my_second_house_member(id).deliver
  end
end
