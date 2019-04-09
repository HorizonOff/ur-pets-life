module PushSending
  class OrderCommentService < PushSending::BaseService
    def initialize(comment, order)
      @comment = comment
      @order = order
      @user = order.user
    end

    private

    attr_reader :comment, :appointment, :user

    def ios_options
      { alert: comment.message,
        sound: 'default',
        source_id: @order.id,
        source_type: 'OrderComment',
        badge: ios_badge,
        unread_commented_appointments_count: unread_commented_appointments_count,
        unread_notifications_count: unread_notifications_count }
    end

    def android_options
      {
        collapse_key: 'type_a',
        data: { body: comment.message,
                title: 'UrPetsLife',
                source_id: @order.id,
                source_type: 'OrderComment',
                badge: android_badge,
                unread_commented_appointments_count: unread_commented_appointments_count }
      }
    end
  end
end
