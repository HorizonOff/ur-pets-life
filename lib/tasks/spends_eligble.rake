namespace :spends_eligble do
  desc 'Parse exel'
  task spends_update: :environment do
    xlsx = Roo::Spreadsheet.open('./public/xlsx/users.xlsx')
    xlsx.each(id: 'user_id', spends_eligble: 'spends_eligble', spends_not_eligble: 'spends_not_eligble') do |hash|
      user = User.find_by(id: hash[:id])
      next if user.blank?

      user.update_column(:spends_eligble, user.spends_eligble - hash[:spends_eligble])
      user.update_column(:spends_not_eligble, user.spends_not_eligble - hash[:spends_not_eligble])
    end
  end
end
