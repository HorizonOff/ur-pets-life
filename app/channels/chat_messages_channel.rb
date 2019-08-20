class ChatMessagesChannel < ApplicationCable::Channel
  def subscribed
    stream_from "chat-#{params['chat_id']}:messages"
    redis_key = "chat-#{params['chat_id']}"
    all_ids = JSON.parse($redis.get(redis_key) || '[]')
    all_ids.push(current_session&.id)
    # all_ids.push(current_user&.id)
    $redis.set(redis_key, all_ids.reject(&:blank?).to_json)
  end

  def unsubscribed
    redis_key = "chat-#{params['chat_id']}"
    all_ids = JSON.parse($redis.get(redis_key) || '[]')
    all_ids.delete(current_session&.id)
    $redis.set(redis_key, all_ids.reject(&:blank?).to_json)
  end
end
