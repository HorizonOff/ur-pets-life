class Schedule < ApplicationRecord
  belongs_to :schedulable, polymorphic: true
  validate :check_hours

  acts_as_paranoid

  DAYS = { '0' => 'sunday',
           '1' => 'monday',
           '2' => 'tuesday',
           '3' => 'wednesday',
           '4' => 'thursday',
           '5' => 'friday',
           '6' => 'saturday' }.freeze

  private

  def check_hours
    return if day_and_night
    check_monday
    check_tuesday
    check_wednesday
    check_thursday
    check_friday
    check_saturday
    check_sunday
  end

  def check_monday
    errors.add(:monday_open_at, 'is required') if monday_close_at.present? && monday_open_at.blank?
    errors.add(:monday_close_at, 'is required') if monday_open_at.present? && monday_close_at.blank?
  end

  def check_tuesday
    errors.add(:tuesday_open_at, 'is required') if tuesday_close_at.present? && tuesday_open_at.blank?
    errors.add(:tuesday_close_at, 'is required') if tuesday_open_at.present? && tuesday_close_at.blank?
  end

  def check_wednesday
    errors.add(:wednesday_open_at, 'is required') if wednesday_close_at.present? && wednesday_open_at.blank?
    errors.add(:wednesday_close_at, 'is required') if wednesday_open_at.present? && wednesday_close_at.blank?
  end

  def check_thursday
    errors.add(:thursday_open_at, 'is required') if thursday_close_at.present? && thursday_open_at.blank?
    errors.add(:thursday_close_at, 'is required') if thursday_open_at.present? && thursday_close_at.blank?
  end

  def check_friday
    errors.add(:friday_open_at, 'is required') if friday_close_at.present? && friday_open_at.blank?
    errors.add(:friday_close_at, 'is required') if friday_open_at.present? && friday_close_at.blank?
  end

  def check_saturday
    errors.add(:saturday_open_at, 'is required') if saturday_close_at.present? && saturday_open_at.blank?
    errors.add(:saturday_close_at, 'is required') if saturday_open_at.present? && saturday_close_at.blank?
  end

  def check_sunday
    errors.add(:sunday_open_at, 'is required') if sunday_close_at.present? && sunday_open_at.blank?
    errors.add(:sunday_close_at, 'is required') if sunday_open_at.present? && sunday_close_at.blank?
  end
end
