class DiagnosisSerializer < ActiveModel::Serializer
  attributes :condition, :message

  attribute :recipes do
    object.recipes.pluck(:instruction)
  end

  attribute :next_appointment do
    object.next_appointment.booked_at unless object.next_appointment_id.nil?
  end
end
