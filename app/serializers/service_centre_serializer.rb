class ServiceCentreSerializer < WorkingHoursSerializer
  attributes :id, :name, :picture_url, :address, :distance, :working_hours, :website, :email, :mobile_number,
             :description, :favorite_id

  has_many :pictures, if: :show_pictures?

  def show_pictures?
    type.in? %w[DayCareCentre GroomingCentre Boarding]
  end
end
