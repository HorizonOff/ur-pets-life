class ChatMessageSerializer < ActiveModel::Serializer
  attributes :id, :m_type, :support_chat_id, :text, :photo,
             :video, :video_duration, :created_at, :timestamp, :system_type

  attribute :status
end
