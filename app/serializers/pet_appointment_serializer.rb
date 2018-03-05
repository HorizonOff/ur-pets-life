class PetAppointmentSerializer < ActiveModel::Serializer
  attributes :id, :name, :avatar_url

  has_many :service_details, serializer: CartItemSerializer do
    scope[:pets_services][object.id]
  end

  has_one :diagnosis do
    scope[:pets_diagnoses][object.id]
  end
end
