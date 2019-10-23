module Parser
  class XlsxParserService
    def process_file(zip_url)
    unzipped_folders_path = []

    #Unzip archive
    Zip::File.open_buffer(open(zip_url)) do |zip_file|
      save_folder_path = Rails.root.join('tmp', 'parser', "#{DateTime.now.to_s(:number)}_#{zip_url.split('/').last.gsub(/ |\./, '_')}")
      FileUtils.rm_rf(save_folder_path)

      unzipped_folders_path << save_folder_path

      zip_file.each do |entry|
        if entry.name.split('/').each do |entry_name|
             break if entry_name.match(/\A\.|\A\_/)
           end

          f_path = File.join(save_folder_path, entry.name)
          FileUtils.mkdir_p(File.dirname(f_path))
          zip_file.extract(entry, f_path) unless File.exist?(f_path)
        end
      end
    end

      unzipped_folders_path.each do |unzipped_folder_path|
        Dir.glob("#{unzipped_folder_path}/**/") do |unzipped_sub_folder_path|
          Dir.glob("#{unzipped_sub_folder_path}/*.xlsx") do |equipments_spreadsheet_path|
            parse_xlsx(equipments_spreadsheet_path, unzipped_sub_folder_path)
          end
        end
      end
    end

    def clean_file
      FileUtils.rm_rf(Rails.root.join('tmp', 'parser'))
    end

    def image_finder(folder_path, image_name)
      Dir.glob("#{folder_path}*.jpg").each do |image_file_name|
        return image_file_name if image_file_name.match?(/#{image_name}/i)
      end

      return nil
    end

    def parse_xlsx(equipments_spreadsheet_path = @tmp_file_path, unzipped_sub_folder_path = @tmp_file_path.split('/')[0..-2].join('/'))
      spreadsheet = Roo::Spreadsheet.open(equipments_spreadsheet_path)
      spreadsheet.each_with_pagename do |sheet_name, sheet|
        sheet.parse(headers: true)[1..-1].each_with_index do |row, index|
          row.keys.each do |key|
            value = row.delete(key).to_s.squish
            row[key.humanize] = value if value.present?
          end

          save_object(row, unzipped_sub_folder_path)
        end
      end
    end

    def save_object(row, unzipped_sub_folder_path)
      image_path = image_finder(unzipped_sub_folder_path, row['Supplier code'])
      item_category_id = ItemCategory.find_by_name(row['Item category']).id
      item_brand_id = ItemBrand.find_by_name(row['Item brand']).id
      image = File.open(image_path)
      weight = row['Weight'].present? ? row['Weight'] : ' '
      Item.create(name: row['Product name'],
                  item_category_ids: [item_category_id],
                  item_brand_ids: [item_brand_id],
                  weight: weight,
                  buying_price: row['Buying price'],
                  unit_price: row['Selling price'],
                  quantity: row['In stock'],
                  supplier: row['Supplier'],
                  supplier_code: row['Supplier code'],
                  short_description: row['Short description'],
                  description: row['Long description'],
                  picture: image)
    end
  end
end
