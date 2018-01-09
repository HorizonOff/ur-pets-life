class AppointmentIndexSerializer < ActiveModel::Serializer
  attributes :id, :start_at, :picture_url, :address, :distance, :working_hours

  def picture_url
    object.bookable.picture.try(:url)
  end

  def address
    object.bookable.location.try(:address)
  end

  def distance
    object.bookable.location.distance_to([scope[:latitude], scope[:longitude]], :km).try(:round, 2) if show_distance?
  end

  def working_hours
    wday = Schedule::DAYS[Time.now.wday.to_s]
    bookable = object.bookable
    { open_at: bookable.schedule.send(wday + '_start_at').strftime('%H:%m'),
      close_at: bookable.schedule.send(wday + '_end_at').strftime('%H:%m') }
  end

  private

  def show_distance?
    scope[:latitude].present? && scope[:longitude].present?
  end
end
