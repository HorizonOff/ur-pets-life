module Api
  module V1
    class PostDecorator < ApplicationDecorator
      decorates :post
      delegate_all

      def image
        model.image.blank? ? image_hash : model.image
      end

      def video
        model.video.blank? ? video_hash : model.video
      end

      def created_at
        model.created_at.to_i
      end

      def unread_post_comments_count
        model.user_posts.find_by(user_id: h.current_user&.id)&.unread_post_comments_count
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
