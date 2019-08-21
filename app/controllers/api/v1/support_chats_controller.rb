module Api
  module V1
    class SupportChatsController < Api::BaseController
      def current_user_support_chat
        @support_chat = current_user.support_chats.without_closed.first
        return render_404 if @support_chat.blank?

        @messages = @support_chat.chat_messages.limit(params[:per_page])
        @messages = ::Api::V1::ChatMessageDecorator.decorate_collection(@messages)
        render json: {
          chat_messages: ActiveModel::Serializer::CollectionSerializer.new(@messages, serializer: ChatMessageSerializer),
          total_count: @messages.count,
          support_chat_id: @support_chat.id
        }
      end

      def close
        @support_chat = current_user.support_chats.without_closed.first
        return render_404 if @support_chat.blank?

        @support_chat.status = 'closed'
        @support_chat.save
        @support_chat.create_message_chat_closed_by_user
        render json: { message: 'Chat closed' }
      end
    end
  end
end
