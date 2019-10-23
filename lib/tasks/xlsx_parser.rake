namespace :xlsx_parser do
  desc 'Parse exel'
  task expiry_date: :environment do
    xlsx = Roo::Spreadsheet.open('./public/xlsx/expiry.xlsx')
    xlsx.each(id: 'Item Number On CMS', month: 'Exp. Date Month', year: 'Exp. Date Year') do |hash|
      item = Item.find_by(id: hash[:id])
      next if hash[:month].blank? || item.blank?

      date = Date.strptime(hash[:month] + ' ' + hash[:year].to_s, '%B %Y')
      item.update_column(:expiry_at, date)
    end
  end
  task supplier: :environment do
    xlsx = Roo::Spreadsheet.open('./public/xlsx/supplier.xlsx')
    xlsx.each(id: 'Item#', supplier: 'Supplier', supplier_code: 'Supplier Code') do |hash|
      item = Item.find_by(id: hash[:id])
      next if item.blank?

      item.update_column(:supplier, hash[:supplier])
      item.update_column(:supplier_code, hash[:supplier_code])
    end
  end
  task item: :environment do
    parser_service =  ::Parser::XlsxParserService.new

    zip_url = './public/xlsx/Photo.zip'
    parser_service.process_file(zip_url)
  end
end
