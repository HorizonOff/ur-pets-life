class Calendar < ApplicationRecord
  belongs_to :vet
  has_one :clinic, through: :vet

  has_many :appointments

  validate :different_days, :calendar_overlaps
  validate :appointments_should_be_valid, on: :update
  validate :start_at_should_be_valid, on: :create

  before_destroy :check_appointments

  scope :overlapsing, (lambda do |id, start_at, end_at|
    where.not(id: id).where('(start_at < :end AND end_at >= :end) OR
                             (start_at <= :start AND end_at > :start) OR
                             (start_at >= :start AND end_at <= :end)', start: start_at, end: end_at)
  end)

  private

  def different_days
    return if the_same_day? || end_at_minight?
    errors.add(:end_at, 'should be the same day as start at')
  end

  def the_same_day?
    start_at.yday == end_at.yday && start_at.year == end_at.year
  end

  def end_at_minight?
    end_at.yday == start_at.next_day.midnight.yday
  end

  def calendar_overlaps
    errors.add(:base, 'Schedule is overlapsing with other schedule') unless overlapsing_calendars.count.zero?
  end

  def overlapsing_calendars
    vet.calendars.overlapsing(id, start_at, end_at)
  end

  def check_appointments
    return true if vet.appointments.where(start_at: start_at..end_at).count.zero?
    errors.add(:base, 'Cannot delete schedule with appointments')
    throw(:abort)
  end

  def appointments_should_be_valid
    appointments_valid = appointments.each do |a|
      break false unless a.valid?
    end
    errors.add(:base, 'Cannot update schedule without changing registered appointments') unless appointments_valid
  end

  def start_at_should_be_valid
    errors.add(:base, 'Slot time should be in the future') if start_at.present? && start_at < current_time
    check_clinic_time if start_at.present?
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
    @day_params ||= { year: current_time.year, month: current_time.month, day: current_time.day }
  end
end
