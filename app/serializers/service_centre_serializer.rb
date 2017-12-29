class ServiceCentreSerializer < ActiveModel::Serializer
  attributes :id, :name, :picture_url, :address, :distance, :working_hours, :website, :email, :mobile_number

  def address
    object.location.try(:address)
  end

  def service_options
    object.service_options.pluck(:name)
  end

  def working_hours
    wday = Schedule::DAYS[Time.now.wday.to_s]
    { open_at: object.schedule.send(wday + '_open_at').strftime('%H:%m'),
      close_at: object.schedule.send(wday + '_close_at').strftime('%H:%m') }
  end

  def distance
    object.location.distance_to([scope[:latitude], scope[:longitude]], :km).try(:round, 2) if show_distance?
  end

  private

  def show_distance?
    object.location.present? && scope[:latitude].present? && scope[:longitude].present?
  end
end
