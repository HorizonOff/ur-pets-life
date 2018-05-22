class NotificationSerializer < ActiveModel::Serializer
  type 'notification'

  attributes :id, :message, :pet_id, :appointment_id, :avatar_url, :created_at, :viewed_at, :source_type, :source_id
end
