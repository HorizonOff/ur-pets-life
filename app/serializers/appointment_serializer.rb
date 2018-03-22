class AppointmentSerializer < ActiveModel::Serializer
  attributes :id, :start_at, :end_at, :bookable_type, :total_price
  attribute :can_be_canceled?, key: :can_be_canceled

  attribute :number_of_days do
    object.number_of_days if object.day_care_or_boarding?
  end

  belongs_to :vet do
    object.vet if object.for_clinic?
  end

  attribute :booked_object do
    ActiveModelSerializers::SerializableResource.new(object.bookable, serializer: AppointmentBookedObjectSerializer,
                                                                      scope: scope, adapter: :attributes)
  end

  attribute :next_appointment do
    object.next_appointment.start_at.to_i if object.next_appointment.present?
  end

  has_many :service_option_details

  has_many :pets, serializer: PetAppointmentSerializer

  def start_at
    object.start_at.to_i
  end

  def end_at
    object.end_at.to_i
  end
end
