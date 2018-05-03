class ServiceCentreSerializer < WorkingHoursSerializer
  attributes :id, :name, :picture_url, :address, :distance, :working_hours, :website, :email, :mobile_number,
             :description, :favorite_id

  has_many :pictures do
    Pet.first.pictures || []
  end
end
