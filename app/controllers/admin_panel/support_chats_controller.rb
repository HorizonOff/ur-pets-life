module AdminPanel
  class SupportChatsController < AdminPanelController
    def index
      @support_chats = SupportChat.all
    end

    def show
      cookies.signed[:user_id] = User.first.id
      @support_chat = SupportChat.includes(:chat_messages).find_by(id: params[:id])
      @chat_message = ChatMessage.new
    end
  end
end
