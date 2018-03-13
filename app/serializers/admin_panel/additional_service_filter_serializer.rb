module AdminPanel
  class AdditionalServiceFilterSerializer < ActiveModel::Serializer
    attributes :id, :name, :picture, :email, :mobile_number, :website, :actions
    attribute :status, key: :is_active
  end
end
