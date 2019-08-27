module AdminPanel
  class SupportChatsController < AdminPanelController
    def index
      @support_chats = SupportChat.all
    end

    def show
      @support_chat = SupportChat.includes(:chat_messages).find_by(id: params[:id])
      @chat_message = ChatMessage.new
    end

    def close
      @support_chat = SupportChat.find_by(id: params[:id])
      @support_chat.update(status: 'closed')
      @support_chat.create_message_chat_closed_by_admin
      render json: { message: 'Chat closed' }
    end
  end
end
