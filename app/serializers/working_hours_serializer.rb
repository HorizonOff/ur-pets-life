class WorkingHoursSerializer < BaseMethodsSerializer
  def working_hours
    @schedule = object.schedule
    return 'Open 24/7' if @schedule.day_and_night?
    @time = Time.now.utc + scope[:time_zone].to_i.hours
    retrieve_wday_schedule
    show_message
  end

  private

  def retrieve_wday_schedule
    @wday = Schedule::DAYS[@time.wday.to_s]
    retrieve_working_hours
  end

  def retrieve_working_hours
    @open_at = @schedule.send(@wday + '_open_at')
    return if @open_at.blank?
    @open_at = change_day(@open_at)
    @close_at = change_day(@schedule.send(@wday + '_close_at'))
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
      'Open today until ' + @close_at.strftime('%I:%M %p')
    end
  end

  def change_day(time)
    time.change(year: @time.year, month: @time.month, day: @time.day)
  end
end
