class ContactRequest < ApplicationRecord
  belongs_to :user
  validates :subject, presence: { message: 'Subject is required' }
  validates :message, presence: { message: 'Message is required' }

  def status
    is_answered? ? 'Answered' : 'New'
  end
end
