class ServiceCentreSerializer < WorkingHoursSerializer
  attributes :id, :name, :picture_url, :address, :distance, :working_hours, :website, :email, :mobile_number,
             :favorite_id
end
