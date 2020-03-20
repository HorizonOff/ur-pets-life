class DownloadInvoicesWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(from_date, to_date)
    AdminPanel::DownloadInvoicesService.new(from_date, to_date)
  end
end
