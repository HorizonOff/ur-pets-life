class CreatePhotoWorker
  include Sidekiq::Worker

  def perform(id, type)
    ::Aws::CreatePhotoService.new(id, type).create_image
  end
end
