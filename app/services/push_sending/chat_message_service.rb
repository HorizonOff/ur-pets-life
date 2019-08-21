module PushSending
  class ChatMessageService < PushSending::BaseService
    def initialize(chat_message, user)
      @chat_message = chat_message
      @user = user
      @chat_message_body = if chat_message.text.present?
                             chat_message.text
                           elsif chat_message.photo.present? || chat_message.mobile_photo_url.present?
                             'Sent you photo'
                           elsif chat_message.video.present? || chat_message.mobile_video_url.present?
                             'Sent you video'
                           end
    end

    private

    attr_reader :chat_message, :chat_message_body, :user, :author

    def ios_options
      { alert: { title: 'UrPetsLife', body: chat_message_body },
        sound: 'default',
        badge: ios_badge,
        # unread_notifications_count: unread_notifications_count,
        # unread_messages_count: unread_messages_count,
        source_type: 'ChatMessage'
      }
    end

    def android_options
      {
        data: { body: chat_message_body,
                title: 'UrPetsLife',
                source_type: 'ChatMessage',
                badge: android_badge
                # unread_notifications_count: unread_notifications_count,
                # unread_messages_count: unread_messages_count
              }
      }
    end
  end
end
