class AppointmentIndexSerializer < WorkingHoursSerializer
  attributes :id, :start_at, :picture_url, :address, :distance, :working_hours, :booked_object

  def start_at
    object.start_at.to_i
  end

  def picture_url
    object.bookable.picture.try(:url)
  end

  def address
    object.bookable.address
  end

  def distance
    object.bookable.location.distance_to([scope[:latitude], scope[:longitude]], :km).try(:round, 2) if show_distance?
  end

  def working_hours
    @schedule = object.bookable.schedule
    return 'Open 24/7' if @schedule.day_and_night?
    @time = Time.now.utc + scope[:time_zone].to_i.hours
    retrieve_wday_schedule
    show_message
  end

  def booked_object
    object.bookable.name
  end
end
