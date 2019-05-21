module Aws
  class DeleteService
    def initialize(link, object, media_type)
      @object = object
      @media_type = media_type
      @region = ENV["AWS_REGION"]
      @bucket = ENV["AWS_BUCKET_NAME"]
      @link = link.split(@bucket + '/')[1]
    end

    def delete
      s3 = Aws::S3::Resource.new(region: @region)
      return unless s3.bucket(@bucket).object(@link).exists?

      s3.bucket(@bucket).object(@link).delete
      if media_type == 'video'
        @object.update_column(:mobile_video_url, nil)
      else
        @object.update_column(:mobile_image_url, nil)
      end
    end

    private

    attr_accessor :link, :bucket, :region, :object, :media_type
  end
end
