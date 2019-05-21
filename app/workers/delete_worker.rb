class DeleteWorker
  include Sidekiq::Worker

  def perform(link, object, media_type)
    ::Aws::DeleteService.new(link, object, media_type).delete
  end
end
