class SupportChatSerializer < ActiveModel::Serializer
  attributes :id

  has_many :chat_messages, serializer: ChatMessageSerializer
end
