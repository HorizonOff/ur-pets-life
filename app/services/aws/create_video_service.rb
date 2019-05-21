module Aws
  class CreateVideoService
    def initialize(id, type)
      @object = Object.const_get(type).find_by(id: id)
    end

    def create_video
      @object.remote_video_url = @object.mobile_video_url
      DeleteWorker.perform_in(10.minutes, @object.mobile_video_url.dup, @object, 'video').delete if @object.save
    end

    private

    attr_accessor :object
  end
end
