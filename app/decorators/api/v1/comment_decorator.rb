module Api
  module V1
    class CommentDecorator < ApplicationDecorator
      decorates :comment
      delegate_all

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

      def user_name_for_admin
        model.commentable_type == 'Post' ? 'UrPetsLife' : model.commentable.bookable.name
      end

      def avatar_url_for_admin
        model.commentable_type == 'Post' ? app_icon : model.commentable.bookable.picture.try(:url)
      end

      def app_icon
        host = ENV['ORIGINAL_URL'].present? ? 'https://' + ENV['ORIGINAL_URL'] : 'localhost:3000'
        host + '/images/AppIcon.png'
      end
    end
  end
end
