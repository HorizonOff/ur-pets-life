class DeleteWorker
  include Sidekiq::Worker

  sidekiq_options retry: false

  def perform(link, object_id, object_type, media_type)
    ::Aws::DeleteService.new(link, object_id, object_type, media_type).delete
  end
end
