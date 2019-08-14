module Api
  module V1
    class ChatMessagesController < Api::BaseController
      def create
        support_chat = current_user.support_chats.without_closed.first
        support_chat ||= current_user.support_chats.create(status: 0)

        message = support_chat.chat_messages.new(message_params)
        message = ::Api::V1::ChatMessageDecorator.decorate(message)
        if message.save
          render json: message, serializer: ChatMessageSerializer
        else
          render_422(parse_errors_messages(message))
        end
      end

      private

      def message_params
        params.require(:chat_message).permit(:text, :m_type, :mobile_photo_url, :mobile_video_url, :video_duration)
      end
    end
  end
end
