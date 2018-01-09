class Calendar < ApplicationRecord
  belongs_to :vet

  has_many :appointments

  validate :different_days, :calendar_overlaps
  validate :appointments_should_be_valid, on: :update

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
end
