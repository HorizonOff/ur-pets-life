class ServiceDetailSerializer < ActiveModel::Serializer
  attributes :id, :pet_type_id, :weight, :total_space, :price
end
