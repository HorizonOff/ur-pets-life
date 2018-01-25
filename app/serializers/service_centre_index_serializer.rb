class ServiceCentreIndexSerializer < WorkingHoursSerializer
  attributes :id, :name, :picture_url, :working_hours, :address, :distance, :type, :favorite_id

  def consultation_fee
    object.consultation_fee if scope[:favorite].present?
  end
end
