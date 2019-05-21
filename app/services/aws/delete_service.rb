module Aws
  class DeleteService
    def initialize(link, object, media_type)
      @region = ENV["AWS_REGION"]
      @bucket = ENV["AWS_BUCKET_NAME"]
      @link = link.split(@bucket + '/')[1]
    end

    def delete
      s3 = Aws::S3::Resource.new(region: @region)
      if s3.bucket(@bucket).object(@link).exists?
        s3.bucket(@bucket).object(@link).delete
        @object.update_column(:mobile_video_url, nil)
      end
    end

    private

    attr_accessor :link, :bucket, :region
  end
end
