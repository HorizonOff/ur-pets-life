class InvoiceMailer < ApplicationMailer
  def send_invoices(zip_data, zip_file_name)
    attachments[zip_file_name] = zip_data
    mail(to: ENV['ADMIN'], subject: 'New ZIP with Invoices')
  end
end

