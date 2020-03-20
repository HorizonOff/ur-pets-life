module AdminPanel
  class DownloadInvoicesService

    def initialize(from_date, to_date)
      @from_date = from_date
      @to_date = to_date
      @pdf_files_path = []

      generate_order_invoices
    end

    private

    attr_reader :from_date, :to_date, :pdf_files_path

    def generate_order_invoices
      formatted_to = Date.strptime(to_date, '%d/%m/%Y').end_of_day
      formatted_from = Date.strptime(from_date, '%d/%m/%Y')
      i = 0

      Order.includes(user: :location, order_items: :item).where("created_at BETWEEN (?) AND (?) AND order_status_flag IN (?)",
                     formatted_from, formatted_to, %w(delivered delivered_by_card delivered_by_cash delivered_online)).each do |order|
        i+= 1

        view = ActionController::Base.new()
        pdf = WickedPdf.new.pdf_from_string(
            view.render_to_string("/admin_panel/invoices/_show.html.erb", layout: "pdf.html.erb",
                                  locals: { order: order, user_address: Location.find_by_id(order.location_id).address }))

        pdf_path = Rails.root.join('tmp', 'INV-' + order.id.to_s + '.pdf')

        File.open(pdf_path, 'wb') do |file|
          file << pdf
        end
        @pdf_files_path << pdf_path

        download_invoice if i == 500
      end
      download_invoice
    end

    def download_invoice
      zip_file_name = "Invoices_#{ Time.now.utc.strftime('%d-%M-%Y') }.zip"
      @temp_zip_file = Tempfile.new(zip_file_name)

      begin
        generate_zip_for_invoices
        zip_data = File.read(@temp_zip_file.path)
        delete_temp_files
        send_invoices(zip_data, zip_file_name).deliver
      ensure
        @pdf_files_path = []
        @temp_zip_file.close
        @temp_zip_file.unlink
      end
    end

    def generate_zip_for_invoices
      Zip::File.open(@temp_zip_file.path, Zip::File::CREATE) do |zip_file|
        @pdf_files_path.each do |pdf_path|
          zip_file.add(pdf_path.to_s.split("/").last, pdf_path)
        end
      end
    end

    def delete_temp_files
      @pdf_files_path.each do |pdf_path|
        File.delete pdf_path
      end
    end

    def send_invoices(zip_data, zip_file_name)
      InvoiceMailer.send_invoices(zip_data, zip_file_name)
    end

  end
end

