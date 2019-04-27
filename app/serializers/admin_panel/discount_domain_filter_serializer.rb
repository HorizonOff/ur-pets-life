module AdminPanel
  class DiscountDomainFilterSerializer < ActiveModel::Serializer
    attributes :domain, :discount, :created_at, :actions
  end
end
