class AppointmentSerializer < ActiveModel::Serializer
  attributes :id, :booked_at, :bookable_type

  belongs_to :vet do
    object.vet if object.for_clinic?
  end

  belongs_to :bookable, key: 'booked_object'

  has_one :diagnosis do
    object.diagnosis if object.for_clinic?
  end
end
