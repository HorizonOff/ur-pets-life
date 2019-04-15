namespace :xlsx_parser do
  desc 'Daily generation time_slots for vets'
  task expiry_date: :environment do
    xlsx = Roo::Spreadsheet.open('./public/xlsx/expiry.xlsx')
    xlsx.each(id: 'Item Number On CMS', month: 'Exp. Date Month', year: 'Exp. Date Year') do |hash|
      item = Item.find_by(id: hash[:id])
      next if hash[:month].blank? || item.blank?

      date = Date.strptime(hash[:month] + ' ' + hash[:year].to_s, '%B %Y')
      item.update_column(:expiry_at, date)
    end
  end
end
