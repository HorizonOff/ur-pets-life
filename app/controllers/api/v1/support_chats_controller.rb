module Api
  module V1
    class SupportChatsController < Api::BaseController

      def current_user_support_chat
        @support_chat = current_user.support_chats.without_closed.first
        return render_404 if @support_chat.blank?

        render json: @support_chat
      end

      def create
        return render_422('Chat already exist') if current_user.support_chats.without_closed.any?

        support_chat = current_user.support_chats.new(support_chat_params)
        if support_chat.save
          render json: { Message: 'Support chat created' }
        else
          render_422(parse_errors_messages(support_chat))
        end
      end

      private

      def support_chat_params
        params.require(:support_chat).permit(:path)
      end
    end
  end
end
