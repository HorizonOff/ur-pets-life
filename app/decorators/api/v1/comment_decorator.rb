module Api
  module V1
    class CommentDecorator < ApplicationDecorator
      decorates :comment
      delegate_all

      def image
        model.image.blank? ? image_hash : model.image
      end

      def created_at
        model.created_at.to_i
      end

      def user_name
        model.writable_type == 'User' ? model.writable.name : user_name_for_admin
      end

      def avatar_url
        model.writable_type == 'User' ? model.writable.avatar.try(:url) : avatar_url_for_admin
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

      def user_name_for_admin
        if model.commentable_type == 'Order'
          'UrPetsLife'
        else
          model.commentable_type == 'Post' ? 'UrPetsLife' : model.commentable.bookable.name
        end
      end

      def avatar_url_for_admin
        if model.commentable_type == 'Order'
          app_icon
        else
          model.commentable_type == 'Post' ? app_icon : model.commentable.bookable.picture.try(:url)
        end
      end
    end
  end
end

