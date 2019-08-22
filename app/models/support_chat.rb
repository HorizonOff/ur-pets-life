class SupportChat < ApplicationRecord
  enum status: { first_message: 0, active: 1, closed: 2 }

  belongs_to :user
  has_many :chat_messages

  scope :without_closed, -> { where.not(status: 2) }

  def create_message_chat_closed_by_user
    chat_messages.create(m_type: 'system', system_type: 'closed_by_user', text: 'Chat closed by user', status: 'posted')
  end

  def reset_unread_messages_count
    self.user_last_visit_at = Time.now
    self.unread_message_count_by_user = 0
    save
  end
end
