module PushSending
  class ChatMessageService < PushSending::BaseService
    def initialize(chat_message, user)
      @chat_message = chat_message.decorate
      @user = user
    end

    private

    attr_reader :chat_message, :user, :author

    def ios_options
      { alert: { title: chat_message.user.name, body: chat_message.text },
        sound: 'default',
        badge: ios_badge,
        # unread_notifications_count: unread_notifications_count,
        # unread_messages_count: unread_messages_count,
        type: 'chat_message',
        chat_message: ActiveModelSerializers::SerializableResource.new(
          chat_message, adapter: :attributes, serializer: ChatMessageSerializer
        ).as_json }
    end

    def android_options
      {
        data: { chat_message: ActiveModelSerializers::SerializableResource.new(
          chat_message, adapter: :attributes, serializer: ChatMessageSerializer
        ).as_json,
                type: 'chat_message',
                title: 'UrPetsLife',
                badge: android_badge
                # unread_notifications_count: unread_notifications_count,
                # unread_messages_count: unread_messages_count
              }
      }
    end
  end
end
