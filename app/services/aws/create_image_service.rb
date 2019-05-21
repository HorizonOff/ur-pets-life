module Aws
  class CreateImageService
    def initialize(id, type)
      @object = Object.const_get(type).find_by(id: id)
    end

    def create_image
      @object.remote_image_url = @object.mobile_image_url
      DeleteWorker.perform_in(10.minutes, @object.mobile_image_url.dup, @object, 'image') if @object.save
    end

    private

    attr_accessor :object
  end
end
