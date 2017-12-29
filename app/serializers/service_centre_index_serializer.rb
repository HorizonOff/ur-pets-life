class ServiceCentreIndexSerializer < PictureUrlSerializer
  attributes :id, :name, :picture_url, :working_hours, :address, :distance

  def address
    object.location.try(:address)
  end

  def distance
    object.location.distance_to([scope[:latitude], scope[:longitude]], :km).try(:round, 2) if show_distance?
  end

  def working_hours
    wday = Schedule::DAYS[Time.now.wday.to_s]
    { open_at: object.schedule.send(wday + '_open_at').strftime('%H:%m'),
      close_at: object.schedule.send(wday + '_close_at').strftime('%H:%m') }
  end

  private

  def show_distance?
    scope[:latitude].present? && scope[:longitude].present?
  end
end
