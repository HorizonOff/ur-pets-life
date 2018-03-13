module AdminPanel
  class NotificationFilterSerializer < ActiveModel::Serializer
    attributes :id, :name, :skip_push_sending, :created_at, :actions
  end
end
