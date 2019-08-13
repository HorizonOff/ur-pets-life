class ChatMessageSerializer < ActiveModel::Serializer
  attributes :id, :support_chat_id, :text, :photo,
             :video, :video_duration, :created_at

  attribute :status
end
