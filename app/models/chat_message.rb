class ChatMessage < ApplicationRecord
  enum status: { pending: 0, posted: 1, error: 2 }
  enum m_type: { user: 0, admin: 1, system: 2 }
  enum system_type: { closed_by_user: 0, closed_by_admin: 1 }

  belongs_to :user, optional: true
  belongs_to :support_chat

  mount_uploader :photo, PhotoUploader
  mount_uploader :video, VideoUploader

  before_validation :set_status

  after_commit :message_to_user, on: :create
  after_commit :create_media_from_url, on: :create

  validate :content_should_be_valid

  validates :photo, file_size: { less_than: 15.megabytes }
  validates :video, file_size: { less_than: 120.megabytes }

  scope :created_after, (lambda do |time|
    where('chat_messages.created_at > ?', time) if time
  end)

  def content_should_be_valid
    errors.add(:base, 'Should be text or video or photo') if photo.blank? && video.blank? && text.blank? &&
                                                             mobile_photo_url.blank? && mobile_video_url.blank?
  end

  def message_to_user
    send_to_channel
    update_user_chats_info
    send_push
  end

  def timestamp
    created_at.strftime('%H:%M:%S %d %B %Y')
  end

  private

  def set_status
    self.status = (mobile_photo_url.present? || mobile_video_url.present?) ? 'pending' : 'posted'
  end

  def content_should_be_valid
    errors.add(:base, 'Should be text or video or photo') if photo.blank? && video.blank? && text.blank? &&
                                                             mobile_photo_url.blank? && mobile_video_url.blank?
  end

  def create_media_from_url
    CreatePhotoWorker.perform_async(id, 'ChatMessage') if mobile_photo_url.present?
    CreateVideoWorker.perform_async(id, 'ChatMessage') if mobile_video_url.present?
  end

  def update_user_chats_info
    return if m_type == 'system'

    if user_id.in?(@user_ids)
      support_chat.unread_message_count_by_user = 0
      support_chat.user_last_visit_at = Time.now
    else
      support_chat.unread_message_count_by_user = support_chat.chat_messages.where(m_type: 'admin')
                                                              .created_after(support_chat.user_last_visit_at).count
    end
    support_chat.save
  end

  def send_push
    return if m_type == 'user'

    resiver_ids = @user_ids.include?(support_chat.user.id) ? [] : [support_chat.user.id]
    PushSendingChatMessageWorker.perform_async(id, resiver_ids)
  end

  def send_to_channel
    redis_key = "chat-#{support_chat_id}"
    @session_ids = JSON.parse($redis.get(redis_key) || '[]').uniq
    user_ids_from_session = Session.where(id: @session_ids).pluck(:client_id)
    @user_ids = user_ids_from_session
    decorated_message = ::Api::V1::ChatMessageDecorator.decorate(self)

    ActionCable.server.broadcast(
      "chat-#{support_chat_id}:messages",
      chat_message: ActiveModelSerializers::SerializableResource.new(decorated_message, adapter: :attributes,
                                                                               serializer: ChatMessageSerializer)
                                                                .as_json
    )
  end
end
