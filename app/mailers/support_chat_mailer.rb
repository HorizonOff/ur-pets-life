class SupportChatMailer < ApplicationMailer
  def send_email_to_admin_on_first_message(support_chat_id)
    @support_chat = SupportChat.find_by(id: support_chat_id)
    mail(to: ENV['SUPPORT_CHAT_EMAIL'], subject: 'New support chat')
  end
end
