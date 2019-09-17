module AdminPanel
  class ChatMessagesController < AdminPanelController
    before_action :load_entities

    def create
      cookies.signed[:user_id] = User.first.id
      @chat_message = ChatMessage.create m_type: 'admin',
                                         support_chat: @support_chat,
                                         text: params.dig(:chat_message, :text),
                                         photo: params.dig(:chat_message, :photo),
                                         video: params.dig(:chat_message, :video)
    end

    protected

    def load_entities
      @support_chat = SupportChat.find params.dig(:chat_message, :support_chat_id)
    end
  end
end
