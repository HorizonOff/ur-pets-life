module Api
  module V1
    class CommentDecorator < ApplicationDecorator
      decorates :comment
      delegate_all

      def image
        model.image.file.blank? ? image_hash : model.image
      end

      def video
        model.video.file.blank? ? video_hash : model.video
      end

      private

      def image_hash
        {
          url: model.mobile_image_url,
          medium: {
            url: model.mobile_image_url
          },
          thumb: {
            url: model.mobile_image_url
          }
        }
      end

      def video_hash
        {
          url: model.mobile_video_url,
          thumb: {
            url: nil
          }
        }
      end
    end
  end
end
