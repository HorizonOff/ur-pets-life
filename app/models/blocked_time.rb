class BlockedTime < ApplicationRecord
  belongs_to :blockable, polymorphic: true
  validate :calendar_overlaps

  scope :overlapsing, (lambda do |id, start_at, end_at|
    where.not(id: id).where('(start_at < :end AND end_at >= :end) OR
                             (start_at <= :start AND end_at > :start) OR
                             (start_at >= :start AND end_at <= :end)', start: start_at, end: end_at)
  end)

  private

  def calendar_overlaps
    errors.add(:base, 'Schedule is overlapsing with other schedule') unless overlapsing_calendars.count.zero?
  end

  def overlapsing_calendars
    blockable.blocked_times.overlapsing(id, start_at, end_at)
  end
end
