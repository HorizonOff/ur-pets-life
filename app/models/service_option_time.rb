class ServiceOptionTime < ApplicationRecord
  belongs_to :service_option_detail

  acts_as_paranoid

  before_validation :set_same_date, on: :create, unless: :some_date_blank?

  validates :start_at, :end_at, presence: true

  validate :values_should_be_valid, unless: :some_date_blank?

  scope :ordered_by_start_at, -> { order(start_at: :asc) }

  def time_range
    start_at.strftime('%l:%M %p').strip + ' - ' + end_at.strftime('%l:%M %p').strip
  end

  private

  def set_same_date
    self.start_at = start_at.change(year: 2018, month: 1, day: 1)
    self.end_at = end_at.change(year: 2018, month: 1, day: 1)
  end

  def values_should_be_valid
    errors.add(:end_at, 'End time should be after start time') if start_at > end_at
  end

  def some_date_blank?
    @some_date_blank ||= start_at.blank? || end_at.blank?
  end
end
