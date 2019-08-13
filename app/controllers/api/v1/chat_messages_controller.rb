module Api
  module V1
    class ChatMessagesController < Api::BaseController
      def create
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
    end
  end
end
