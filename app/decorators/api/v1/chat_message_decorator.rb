module Api
  module V1
    class ChatMessageDecorator < ApplicationDecorator
      decorates :chat_message
      delegate_all

      def photo
        model.photo.blank? ? photo_hash : model.photo
      end

      def video
        model.video.blank? ? video_hash : model.video
      end

      def created_at
        model.created_at.to_i
      end

      private

      def photo_hash
        {
          url: model.mobile_photo_url,
          medium: {
            url: model.mobile_photo_url
          },
          thumb: {
            url: model.mobile_photo_url
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
