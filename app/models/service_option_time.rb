class ServiceOptionTime < ApplicationRecord
  belongs_to :service_option_detail

  acts_as_paranoid

  before_validation :set_same_date, on: :create

  validates :start_at, :end_at, presence: true

  private

  def set_same_date
    return if start_at.blank? || end_at.blank?
    self.start_at = start_at.change(year: 2018, month: 1, day: 1)
    self.end_at = end_at.change(year: 2018, month: 1, day: 1)
  end
end
