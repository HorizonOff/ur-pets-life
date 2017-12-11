class ServiceCentreIndexSerializer < ActiveModel::Serializer
  attributes :id, :name, :picture_url, :working_hours, :address, :distance

  def distance
    object.location.distance_to([scope[:latitude], scope[:longitude]], :km).round(2) if show_distance
  end

  def working_hours
    wday = Schedule::DAYS[Time.now.wday.to_s]
    { open_at: object.schedule.send(wday + '_start_at'), close_at: object.schedule.send(wday + '_end_at') }
  end

  def picture_url
    object.picture.try(:url)
  end

  private

  def show_distance
    scope[:latitude].present? && scope[:longitude].present?
  end
end
