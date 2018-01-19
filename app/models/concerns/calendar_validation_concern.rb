module CalendarValidationConcern
  extend ActiveSupport::Concern

  included do
    validate :start_at_should_be_valid, on: :create
  end

  private

  def start_at_should_be_valid
    errors.add(:base, 'Slot time should be in the future') if start_at.present? && start_at < current_time
  end

  def check_clinic_time
    return if clinic.schedule.day_and_night?
    wday_string = Schedule::DAYS[start_at.wday.to_s]
    @open_at_string = wday_string + '_open_at'
    return errors.add(:base, 'Clinic is not available at this time') if @open_at_string.blank?
    @close_at_string = wday_string + '_close_at'
    check_current_day_schedule
  end

  def check_current_day_schedule
    compare_clinic_time(clinic.schedule.send(@open_at_string).change(day_params),
                        clinic.schedule.send(@close_at_string).change(day_params))
  end

  def compare_clinic_time(clinic_open, clinic_close)
    message = 'Clinic working hours: ' + clinic_open.strftime('%I:%M %p') + ' - ' + clinic_close.strftime('%I:%M %p')
    errors.add(:base, message) if start_at < clinic_open || end_at > clinic_close
  end

  def current_time
    @current_time ||= Time.current
  end

  def day_params
    @day_params ||= { year: start_at.year, month: start_at.month, day: start_at.day }
  end

  def time_should_be_valid
    return if bookable_type != 'Clinic'
    errors.add(:base, 'Vet is unavailable at this time') if calendar_id.nil? || !within_the_schedule?
  end

  def within_the_schedule?
    time_range = calendar.start_at.utc..calendar.end_at.utc
    start_at.utc.in?(time_range) && end_at.utc.in?(time_range)
  end
end
