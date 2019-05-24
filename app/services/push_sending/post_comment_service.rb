module PushSending
  class PostCommentService < PushSending::BaseService
    def initialize(comment, post, user)
      @comment = comment
      @post = post
      @user = user
    end

    private

    attr_reader :comment, :post, :user

    def ios_options
      { alert: comment.message,
        title: post.title,
        sound: 'default',
        source_id: post.id,
        source_type: 'PostComment',
        badge: ios_badge,
        unread_commented_appointments_count: unread_commented_appointments_count,
        unread_notifications_count: unread_notifications_count }
    end

    def android_options
      {
        collapse_key: 'type_a',
        data: { body: comment.message,
                title: post.title,
                source_id: post.id,
                source_type: 'PostComment',
                badge: android_badge,
                unread_commented_appointments_count: unread_commented_appointments_count }
      }
    end
  end
end
