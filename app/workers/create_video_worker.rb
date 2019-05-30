class CreateVideoWorker
  include Sidekiq::Worker

  def perform(id, type)
    ::Aws::CreateVideoService.new(id, type).create_video
  end
end
