module AdminPanel
  class ContactRequestFilterSerializer < BaseMethodsSerializer
    attributes :id, :user_name, :email, :user_mobile_number, :subject, :created_at, :actions
    attribute :status, key: :is_answered
  end
end
