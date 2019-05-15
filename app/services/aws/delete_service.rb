module Aws
  class DeleteService
    def initialize(link)
      @region = ENV["AWS_REGION"]
      @bucket = ENV["AWS_BUCKET_NAME"]
      @link = link.split(@bucket + '/')[1]
    end

    def delete
      response = { deleted: false }
      s3 = Aws::S3::Resource.new(region: @region)
      if s3.bucket(@bucket).object(@link).exists?
        s3.bucket(@bucket).object(@link).delete
        response[:deleted] = true
      end
      response
    end

    private

    attr_accessor :link, :bucket, :region
  end
end
