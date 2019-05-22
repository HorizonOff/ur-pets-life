module Aws
  class CreateVideoService
    def initialize(id, type)
      @object = Object.const_get(type).find_by(id: id)
    end

    def create_video
      @object.remote_video_url = @object.mobile_video_url
      if @object.save
        DeleteWorker.perform_in(10.minutes, @object.mobile_video_url.dup, @object.id, @@object.class.to_s, 'video')
      end
    end

    private

    attr_accessor :object
  end
end
