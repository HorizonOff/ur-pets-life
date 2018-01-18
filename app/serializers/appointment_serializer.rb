class AppointmentSerializer < ActiveModel::Serializer
  attributes :id, :start_at, :bookable_type

  belongs_to :vet do
    object.vet if object.for_clinic?
  end

  belongs_to :bookable, key: 'booked_object'

  has_one :diagnosis do
    object.diagnosis if object.for_clinic?
  end

  def start_at
    object.start_at.to_i
  end
end
