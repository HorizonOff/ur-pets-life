class Comment < ApplicationRecord
  belongs_to :writable,    -> { with_deleted }, polymorphic: true
  belongs_to :commentable, -> { with_deleted }, polymorphic: true, counter_cache: true

  counter_culture :commentable, column_name: proc { |model| model.commentable_type == 'Appointment' && model.writable_type == 'User' && model.read_at.blank? ? 'unread_comments_count_by_admin' : nil },
                                column_names: { ["comments.commentable_type = 'Appointment' AND comments.writable_type = 'User' AND comments.read_at IS NULL"] => 'unread_comments_count_by_admin' }

  counter_culture :commentable, column_name: proc { |model| model.commentable_type == 'Order' && model.writable_type == 'User' && model.read_at.blank? ? 'unread_comments_count_by_admin' : nil },
                                column_names: { ["comments.commentable_type = 'Order' AND comments.writable_type = 'User' AND comments.read_at IS NULL"] => 'unread_comments_count_by_admin' }

  counter_culture :commentable, column_name: proc { |model| model.commentable_type == 'Appointment' && model.writable_type == 'Admin' && model.read_at.blank? ? 'unread_comments_count_by_user' : nil },
                                column_names: { ["comments.commentable_type = 'Appointment' AND comments.writable_type = 'Admin' AND comments.read_at IS NULL"] => 'unread_comments_count_by_user' }

  counter_culture :commentable, column_name: proc { |model| model.commentable_type == 'Order' && model.writable_type == 'Admin' && model.read_at.blank? ? 'unread_comments_count_by_user' : nil },
                                column_names: { ["comments.commentable_type = 'Order' AND comments.writable_type = 'Admin' AND comments.read_at IS NULL"] => 'unread_comments_count_by_user' }

  validates :message, presence: { message: 'Message is required' }

  acts_as_paranoid

  mount_uploader :image, PhotoUploader

  after_commit :send_notification, :create_image_from_url, on: :create
  after_commit :update_counters

  def send_notification
    return if Rails.env.test?
    if (commentable_type == 'Order' and writable_type == 'Admin')
      PushSendingOrderCommentWorker.perform_async(id, commentable_id)
    elsif (commentable_type == 'Order' and writable_type == 'User')
      EmailOrderCommentWorker.perform_async(commentable_id)
    else
      PushSendingCommentWorker.perform_async(id, commentable_id) if should_send_push?
      EmailCommentWorker.perform_async(commentable_id) if should_send_email?
    end
  end

  def create_image_from_url
    CreateImageWorker.perform_async(id, 'Comment') if mobile_image_url.present?
  end

  def update_counters
    return if (commentable_type != 'Appointment' and commentable_type != 'Order')
    if commentable_type == 'Order'
      commentable.user.update_counters_for_order
    else
      commentable.admin&.update_counters if writable_type == 'User'
      commentable.user.update_counters
    end
  end

  def self.read_by_user
    # where(writable_type: 'Admin', read_at: nil).update_all(read_at: Time.current)
    select { |c| c.writable_type == 'Admin' && c.read_at.blank? }.each do |c|
      c.update_column(:read_at, Time.current)
    end
  end

  def self.read_by_admin
    # where(writable_type: 'User', read_at: nil).update_all(read_at: Time.current)
    select { |c| c.writable_type == 'User' && c.read_at.blank? }.each do |c|
      c.update_column(:read_at, Time.current)
    end
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
