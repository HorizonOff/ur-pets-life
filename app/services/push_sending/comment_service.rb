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
        badge: unread_notifications_count,
        appointment_id: appointment.id,
        type: 'AppointmentComment' }
    end

    def android_options
      {
        collapse_key: 'type_a',
        data: { body: comment.message,
                title: 'UrPetsLife',
                appointment_id: appointment.id,
                badge: unread_notifications_count,
                type: 'AppointmentComment' }
      }
    end
  end
end
