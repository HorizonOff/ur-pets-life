module PushSending
  class ChatMessageService < PushSending::BaseService
    def initialize(chat_message, user)
      @chat_message = ::Api::V1::ChatMessageDecorator.decorate(chat_message)
      @user = user
    end

    private

    attr_reader :chat_message, :user, :author

    def ios_options
      { alert: { title: 'UrPetsLife', body: chat_message.text },
        sound: 'default',
        badge: ios_badge,
        # unread_notifications_count: unread_notifications_count,
        # unread_messages_count: unread_messages_count,
        source_type: 'ChatMessage',
        chat_message: ActiveModelSerializers::SerializableResource.new(
          chat_message, adapter: :attributes, serializer: ChatMessageSerializer
        ).as_json }
    end

    def android_options
      {
        data: { chat_message: ActiveModelSerializers::SerializableResource.new(
          chat_message, adapter: :attributes, serializer: ChatMessageSerializer
        ).as_json,
                source_type: 'ChatMessage',
                title: 'UrPetsLife',
                badge: android_badge
                # unread_notifications_count: unread_notifications_count,
                # unread_messages_count: unread_messages_count
              }
      }
    end
  end
end
