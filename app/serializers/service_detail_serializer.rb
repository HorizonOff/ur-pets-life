class ServiceDetailSerializer < ActiveModel::Serializer
  attributes :id, :pet_type_id, :weight, :price
end
