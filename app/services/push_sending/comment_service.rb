module PushSending
  class CommentService < PushSending::BaseService
    def initialize(comment, appointment)
      @comment = comment
      @appointment = appointment
      @user = appointment.user
    end

    private

    attr_reader :comment, :appointment, :user

    def ios_options
      { alert: comment.message,
        sound: 'default',
        source_id: appointment.id,
        source_type: 'AppointmentComment',
        badge: ios_badge,
        unread_commented_appointments_count: unread_commented_appointments_count,
        unread_notifications_count: unread_notifications_count,
        unread_post_comments_count: unread_post_comments_count }
    end

    def android_options
      {
        collapse_key: 'type_a',
        data: { body: comment.message,
                title: 'UrPetsLife',
                source_id: appointment.id,
                source_type: 'AppointmentComment',
                badge: android_badge,
                unread_commented_appointments_count: unread_commented_appointments_count,
                unread_notifications_count: unread_notifications_count,
                unread_post_comments_count: unread_post_comments_count }
      }
    end
  end
end
