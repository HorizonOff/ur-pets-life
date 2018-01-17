class ServiceCentreIndexSerializer < PictureUrlSerializer
  attributes :id, :name, :picture_url, :working_hours, :address, :distance

  def distance
    object.location.distance_to([scope[:latitude], scope[:longitude]], :km).try(:round, 2) if show_distance?
  end

  def working_hours
    return 'Open 24/7' if object.schedule.day_and_night?
    @time = Time.now.utc + scope[:time_zone].to_i.hours
    retrieve_wday_schedule
    show_message
  end

  private

  def show_distance?
    scope[:latitude].present? && scope[:longitude].present?
  end

  def retrieve_wday_schedule
    @wday = Schedule::DAYS[@time.wday.to_s]
    retrieve_working_hours
  end

  def retrieve_working_hours
    @open_at = object.schedule.send(@wday + '_open_at')
    return if @open_at.blank?
    @open_at = change_day(@open_at)
    @close_at = change_day(object.schedule.send(@wday + '_close_at'))
  end

  def show_message
    if @open_at.blank? || @time > @close_at
      find_next_working_day
    else
      check_if_open
    end
  end

  def find_next_working_day
    loop do
      @time += 1.day
      retrieve_wday_schedule
      break if @open_at.present?
    end
    'Open ' + @open_at.strftime('%-d %b at %I:%M %p')
  end

  def check_if_open
    if @time < @open_at
      'Open ' + @open_at.strftime('%-d %b at %I:%M %p')
    else
      'Open today until ' + @open_at.strftime('%I:%M %p')
    end
  end

  def change_day(time)
    time.change(year: @time.year, month: @time.month, day: @time.day)
  end
end
