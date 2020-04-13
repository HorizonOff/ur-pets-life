namespace :spends do
  desc 'Create UserPost for all comment and post'
  task update: :environment do
    xlsx = Roo::Spreadsheet.open('./public/xlsx/spends.xlsx')
    xlsx.each(id: 'user_id', spends_eligble: 'spends_eligble', spends_not_eligble: 'spends_not_eligble') do |hash|
      user = User.find_by_id(hash[:id])
      next if user.blank?

      user.update_column(:spends_eligble, user.spends_eligble - hash[:spends_eligble])
      user.update_column(:spends_not_eligble, user.spends_not_eligble - hash[:spends_not_eligble])
    end
  end
end