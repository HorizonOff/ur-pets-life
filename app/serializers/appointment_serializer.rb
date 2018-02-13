class AppointmentSerializer < ActiveModel::Serializer
  attributes :id, :start_at, :bookable_type, :total_price, :service_type_names

  belongs_to :vet do
    object.vet if object.for_clinic?
  end

  belongs_to :pet, serializer: PetIndexSerializer

  belongs_to :bookable, key: 'booked_object'

  has_one :diagnosis do
    object.diagnosis if object.for_clinic?
  end

  attribute :next_appointment do
    object.next_appointment.start_at.to_i if object.next_appointment.present?
  end

  def service_type_names
    object.service_types.pluck(:name)
  end

  def start_at
    object.start_at.to_i
  end
end
