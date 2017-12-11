class ServiceCentreSerializer < ActiveModel::Serializer
  attributes :id, :name, :picture_url, :address, :distance, :working_hours, :website

  def address
    object.location.try(:address)
  end

  def service_options
    object.service_options.pluck(:name)
  end

  def working_hours
    wday = Schedule::DAYS[Time.now.wday.to_s]
    { open_at: object.schedule.send(wday + '_start_at'), close_at: object.schedule.send(wday + '_end_at') }
  end

  def picture_url
    object.picture.try(:url)
  end

  def distance
    object.location.distance_to([scope[:latitude], scope[:longitude]], :km).round(2) if show_distance?
  end

  private

  def show_distance?
    object.location.present? && scope[:latitude].present? && scope[:longitude].present?
  end
end
