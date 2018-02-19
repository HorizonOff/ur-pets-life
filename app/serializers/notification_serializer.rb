class NotificationSerializer < BaseMethodsSerializer
  type 'notification'

  attributes :id, :message, :pet_id, :appointment_id, :avatar_url, :created_at

  def avatar_url
    if object.pet_id
      object.pet.avatar.try(:url)
    elsif object.appointment_id
      object.appointment.bookable.picture.try(:url)
    end
  end
end
