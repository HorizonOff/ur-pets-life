class PushSendingChatMessageWorker
  include Sidekiq::Worker

  sidekiq_options queue: :push_and_sms

  def perform(id, user_ids)
    @chat_message = ChatMessage.find_by(id: id)
    @users = User.where(id: user_ids).includes(:sessions)
    @users.each { |user| push_sending_service(user).send_push }
  end

  private

  def push_sending_service(user)
    ::PushSending::ChatMessageService.new(@chat_message, user)
  end
end
