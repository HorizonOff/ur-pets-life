class Schedule < ApplicationRecord
  belongs_to :schedulable, polymorphic: true

  before_validation :set_same_date

  validate :check_hours

  acts_as_paranoid

  DAYS = { '0' => 'sunday',
           '1' => 'monday',
           '2' => 'tuesday',
           '3' => 'wednesday',
           '4' => 'thursday',
           '5' => 'friday',
           '6' => 'saturday' }.freeze

  def self.open_at_field_name(day)
    day + '_open_at'
  end

  def self.close_at_field_name(day)
    day + '_close_at'
  end

  def open_at_field(day)
    send(Schedule.open_at_field_name(day))
  end

  def close_at_field(day)
    send(Schedule.close_at_field_name(day))
  end

  private

  def set_same_date
    DAYS.each_value do |name|
      next if open_at_field(name).blank? || close_at_field(name).blank?
      self[Schedule.open_at_field_name(name)] = open_at_field(name).change(year: 2018, month: 1, day: 1)
      self[Schedule.close_at_field_name(name)] = close_at_field(name).change(year: 2018, month: 1, day: 1)
    end
  end

  def check_hours
    return if day_and_night?
    DAYS.each_value do |name|
      check_day(name)
      check_timeline(name)
    end
  end

  def check_day(name)
    errors.add(Schedule.open_at_field_name(name).to_sym, 'is required') if open_at_blank?(name)
    errors.add(Schedule.close_at_field_name(name).to_sym, 'is required') if close_at_blank?(name)
  end

  def open_at_blank?(name)
    close_at_field(name).present? && open_at_field(name).blank?
  end

  def close_at_blank?(name)
    open_at_field(name).present? && close_at_field(name).blank?
  end

  def check_timeline(name)
    errors.add(Schedule.close_at_field_name(name).to_sym, 'should be after opening time') unless timeline_correct?(name)
  end

  def timeline_correct?(name)
    return if open_at_field(name).blank? || close_at_field(name).blank?
    open_at_field(name) < close_at_field(name)
  end
end
