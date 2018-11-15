class ServiceOptionDetailSerializer < ActiveModel::Serializer
  attributes :id, :service_option_id, :name, :price

  has_many :service_option_times
end
