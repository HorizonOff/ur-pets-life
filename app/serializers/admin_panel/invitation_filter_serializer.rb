module AdminPanel
  class InvitationFilterSerializer < ActiveModel::Serializer
    attributes :id, :email, :created_at
  end
end
