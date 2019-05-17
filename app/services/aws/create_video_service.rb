module Aws
  class CreateImageService
    def initialize(id, type)
      @object = Object.const_get(type).find_by(id: id)
    end

    def create_video
      @object.remote_video_url = @object.mobile_video_url
      if @object.save && @object.video.present? && ::Aws::DeleteService.new(@object.mobile_video_url.dup).delete
        @object.update_column(:mobile_video_url, nil)
      end
    end

    private

    attr_accessor :object
  end
end
