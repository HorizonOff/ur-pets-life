class LocationChannel < ApplicationCable::Channel
  def subscribed
    stream_from "driver-#{params['driver_id']}:location"
    redis_key = "admin_location:#{params['driver_id']}"
    all_ids = JSON.parse($redis.get(redis_key) || '[]')
    all_ids.push(current_session&.id)
    $redis.set(redis_key, all_ids.reject(&:blank?).to_json)
  end

  def unsubscribed
    redis_key = "admin_location:#{params['driver_id']}"
    all_ids = JSON.parse($redis.get(redis_key) || '[]')
    all_ids.delete(current_session&.id)
    $redis.set(redis_key, all_ids.reject(&:blank?).to_json)
  end
end

