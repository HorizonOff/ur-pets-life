class CreateImageWorker
  include Sidekiq::Worker

  def perform(id, type)
    ::Aws::CreateImageService.new(id, type).create_image
  end
end
