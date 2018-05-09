class Comment < ApplicationRecord
  belongs_to :writable,    -> { with_deleted }, polymorphic: true
  belongs_to :commentable, -> { with_deleted }, polymorphic: true, counter_cache: true

  validates :message, presence: { message: 'Message is required' }

  acts_as_paranoid

  after_commit :send_notification, on: :create

  def send_notification
    return if Rails.env.test?
    PushSendingCommentJob.perform_async(id, commentable_id) if commentable_type == 'Appointment' && writable_type == 'Admin'
  end
end
