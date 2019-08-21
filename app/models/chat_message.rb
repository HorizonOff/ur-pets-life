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

  def content_should_be_valid
    errors.add(:base, 'Should be text or video or photo') if photo.blank? && video.blank? && text.blank? &&
                                                             mobile_photo_url.blank? && mobile_video_url.blank?
  end

  def message_to_user
    send_to_channel
    # update_user_chats_info
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
    chat.user_chats.each do |user_chat|
      user_chat.deleted_at = nil
      if user_chat.user_id.in?(@user_ids)
        user_chat.last_visit_at = Time.now
        user_chat.unread_messages_count = 0
        user_chat.visible_messages_count = chat.chat_messages.created_after(user_chat.visible_from).count
      else
        user_chat.visible_messages_count = chat.chat_messages.created_after(user_chat.visible_from).count
        user_chat.unread_messages_count = chat.chat_messages.where.not(user_id: user_chat.user_id)
                                              .created_after(user_chat.last_visit_at).count
      end
      user_chat.save
    end
  end

  def send_push
    return if m_type == 'user'

    resiver_ids = @user_ids.include?(support_chat.user.id) ? [] : [support_chat.user.id]
    PushSendingChatMessageWorker.perform_async(id, resiver_ids)
  end

  def send_to_channel
    redis_key = "chat-#{support_chat_id}"
    @session_ids = JSON.parse($redis.get(redis_key) || '[]').uniq
    user_ids_from_session = Session.where(id: @session_ids).pluck(:user_id)
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
