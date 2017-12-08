class GroomingCentreSerializer < ActiveModel::Serializer
  type 'grooming_centre'

  attributes :id, :name, :picture, :address, :distance, :working_hours, :website, :service_options
  has_many :service_types do
    object.service_types.includes(:service_details)
  end

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

  def distance
    [nil, '15km', '2km'].sample
  end
end
