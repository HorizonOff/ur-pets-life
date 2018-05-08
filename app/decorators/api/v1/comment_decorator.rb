module Api
  module V1
    class CommentDecorator < ApplicationDecorator
      decorates :comment
      delegate_all

      def created_at
        model.created_at.to_i
      end

      def user_name
        model.writable.name
      end

      def avatar_url
        model.writable.avatar.try(:url)
      end
    end
  end
end
