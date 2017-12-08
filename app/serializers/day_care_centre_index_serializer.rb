class DayCareCentreIndexSerializer < ActiveModel::Serializer
  type 'day_care_centre'

  attributes :id, :name, :picture, :address, :distance, :working_hours

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
