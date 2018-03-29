class AppointmentSerializer < ActiveModel::Serializer
  attributes :id, :bookable_type, :total_price, :comment
  attribute :can_be_canceled?, key: :can_be_canceled

  attribute :dates do
    int_dates = []
    if object.for_day_care?
      object.dates.each do |d|
        int_dates << Time.zone.parse(d).to_i
      end
    end
    int_dates
  end

  attribute :time_slot do
    time_slot = {}
    time_slot[:start_at] = object.start_at.to_i
    time_slot[:end_at] = object.end_at.to_i
    time_slot[:number_of_days] = object.number_of_days if object.day_care_or_boarding?
    time_slot
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
end
