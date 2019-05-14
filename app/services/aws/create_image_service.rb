module Aws
  class CreateImageService
    def initialize(id, type)
      @object = Object.const_get(type).find_by(id: id)
    end

    def create_image
      @object.remote_image_url = @object.mobile_image_url
      if @object.save && @object.image.present? && ::Aws::DeleteService.new(@object.mobile_image_url.dup).delete
        @object.mobile_image_url = nil
      end
    end

    private

    attr_accessor :object
  end
end
