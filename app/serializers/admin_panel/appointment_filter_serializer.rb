module AdminPanel
  class AppointmentFilterSerializer < BaseMethodsSerializer
    attributes :id, :actions, :vet_name, :created_at, :start_at
    attribute :status_label, key: :status
    attribute :booked_object, key: :bookable_type
    attribute :user_name, key: :name
  end
end
