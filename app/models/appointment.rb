class Appointment < ApplicationRecord
  belongs_to :user
  belongs_to :bookable, polymorphic: true
  belongs_to :pet
  belongs_to :vet, optional: true
  belongs_to :calendar, optional: true

  has_one :diagnosis, dependent: :destroy

  has_and_belongs_to_many :service_details

  before_validation :set_calendar
  validates :start_at, presence: { message: 'Date and time are required' }
  validate :vet_id_should_be_vaild, :pet_id_should_be_valid, :service_ids_should_be_valid
  validate :time_should_be_valid, :appointmet_overlaps

  before_create :set_price
  before_create :set_end_time

  scope :past, -> { where('start_at < ?', Time.current).order(start_at: :desc) }
  scope :upcoming, -> { where('start_at > ?', Time.current).order(start_at: :asc) }
  scope :for_clinic, -> { where(bookable_type: 'Clinic') }
  scope :overlapsing, (lambda do |id, start_at, end_at|
    where.not(id: id).where('(start_at < :end AND end_at >= :end) OR
                             (start_at <= :start AND end_at > :start) OR
                             (start_at >= :start AND end_at <= :end)', start: start_at, end: end_at)
  end)

  def for_clinic?
    @for_clinic ||= bookable_type == 'Clinic'
  end

  private

  def vet_id_should_be_vaild
    if bookable_type == 'Clinic' && bookable
      errors.add(:vet_id, 'Vet is invalid') unless bookable.vet_ids.include?(vet_id)
      errors.add(:vet_id, 'Vet is required') if vet_id.blank?
    else
      self.vet_id = nil
    end
  end

  def service_ids_should_be_valid
    if bookable_type == 'Clinic'
      self.service_detail_ids = []
    else
      check_services_count
      check_services if service_detail_ids.present?
    end
  end

  def check_services
    services_valid = service_details.each do |sd|
      break false if sd.pet_type_id != pet.pet_type_id
    end
    errors.add(:service_detail_ids, '1 of Services is invalid') unless services_valid
  end

  def check_services_count
    errors.add(:service_detail_ids, 'Booking service is required') if service_detail_ids.empty?
    errors.add(:service_detail_ids, 'Should be only 1 service in booking') if bookable_type == 'DayCareCenre' && \
                                                                              service_detail_ids.size > 1
  end

  def pet_id_should_be_valid
    errors.add(:pet_id, 'Pet is invalid') unless user.pet_ids.include?(pet_id)
  end

  def set_calendar
    return if bookable_type != 'Clinic' || calendar_id.present? || vet_id.blank?
    current_vet_calendar = vet.calendars.where('start_at <= ? AND end_at >= ?', start_at, end_at).first
    self.calendar = current_vet_calendar if current_vet_calendar
  end

  def time_should_be_valid
    return if bookable_type != 'Clinic'
    errors.add(:base, 'Vet is unavailable at this time') if calendar_id.nil? || !within_the_schedule?
  end

  def within_the_schedule?
    time_range = calendar.start_at.utc..calendar.end_at.utc
    start_at.utc.in?(time_range) && end_at.utc.in?(time_range)
  end

  def appointmet_overlaps
    return if bookable_type != 'Clinic' || vet_id.blank?
    errors.add(:base, 'Appointment is overlapsing with other appointment') unless overlapsing_appointments.count.zero?
  end

  def overlapsing_appointments
    vet.appointments.overlapsing(id, start_at, end_at)
  end

  def set_price
    return self.total_price = vet.consultation_fee if vet_id.present?
    self.total_price = service_details.sum(&:price)
  end

  def set_end_time
    return if vet_id.blank? || vet.nil?
    self.end_at = appointment.start_at + vet.session_duration.minutes
  end
end
