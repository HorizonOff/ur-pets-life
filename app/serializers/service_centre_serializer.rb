class ServiceCentreSerializer < WorkingHoursSerializer
  attributes :id, :name, :picture_url, :address, :distance, :working_hours, :website, :email, :mobile_number

  def service_options
    object.service_options.pluck(:name)
  end
end
