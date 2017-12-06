class ClinicSerializer < ActiveModel::Serializer
  type 'clinic'

  attributes :id, :name, :picture, :address, :distance, :consultation_fee, :working_hours, :website

  def picture
    object.picture.try(:url)
  end

  def address
    object.location.try(:address)
  end

  def working_hours
    wday = Schedule::DAYS[Time.now.wday.to_s]
    { open_at: object.schedule.send(wday + '_start_at'), close_at: object.schedule.send(wday + '_end_at') }
  end

  def distance
    [nil, '15km', '2km'].sample
  end
end
