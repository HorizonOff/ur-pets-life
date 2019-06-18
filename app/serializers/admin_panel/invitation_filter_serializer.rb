module AdminPanel
  class InvitationFilterSerializer < ActiveModel::Serializer
    attributes :id, :name, :email, :unsubscribe, :created_at
  end
end
