class Comment < ApplicationRecord
  belongs_to :writable,    -> { with_deleted }, polymorphic: true
  belongs_to :commentable, -> { with_deleted }, polymorphic: true, counter_cache: true

  validates :message, presence: { message: 'Message is required' }

  acts_as_paranoid

  after_commit :send_notification, on: :create

  def send_notification
    return if Rails.env.test?
    PushSendingCommentJob.perform_async(id, commentable_id) if should_send_push?
    EmailCommentJob.perform_async(commentable_id) if should_send_email?
  end

  private

  def should_send_push?
    for_appointment? && from_admin?
  end

  def should_send_email?
    for_appointment? && !from_admin?
  end

  def for_appointment?
    @for_appointment ||= commentable_type == 'Appointment'
  end

  def from_admin?
    @from_admin ||= writable_type == 'Admin'
  end
end
