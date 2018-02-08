class Appointment < ApplicationRecord
  include CalendarValidationConcern

  STATUS_OPTIONS = %i[pending accepted rejected].freeze
  enum status: STATUS_OPTIONS

  belongs_to :user
  belongs_to :bookable, polymorphic: true
  belongs_to :admin, optional: true
  belongs_to :pet
  belongs_to :vet, optional: true
  belongs_to :calendar, optional: true
  belongs_to :main_appointment, class_name: 'Appointment', optional: true

  has_one :diagnosis, dependent: :destroy
  has_one :next_appointment, class_name: 'Appointment', foreign_key: :main_appointment_id

  has_many :cart_items
  has_many :service_details, through: :cart_items

  after_initialize :set_defaults

  before_validation :set_end_at, :set_calendar, :set_admin, on: :create
  validates :start_at, presence: { message: 'Date and time are required' }
  validate :vet_id_should_be_vaild, :pet_id_should_be_valid, :service_ids_should_be_valid, :time_should_be_valid,
           :appointmet_overlaps

  after_validation :set_price, on: :create

  scope :past, -> { where('start_at < ?', Time.current).order(start_at: :desc) }
  scope :upcoming, -> { where('start_at > ?', Time.current).order(start_at: :asc) }
  scope :for_clinic, -> { where(bookable_type: 'Clinic') }
  scope :without_rejected, -> { where(status: %i[pending accepted]) }
  scope :overlapsing, (lambda do |id, start_at, end_at|
    without_rejected.where.not(id: id).where('(start_at < :end AND end_at >= :end) OR
                                              (start_at <= :start AND end_at > :start) OR
                                              (start_at >= :start AND end_at <= :end)', start: start_at, end: end_at)
  end)

  def for_clinic?
    @for_clinic ||= bookable_type == 'Clinic'
  end

  def past?
    start_at <= current_time
  end

  def start_at=(value)
    value = Time.zone.at(value.to_i)
    super
  end

  private

  def set_defaults
    return if persisted? && status.present?
    self.status ||= :pending
  end

  def set_admin
    self.admin_id = bookable.admin_id
  end

  def vet_id_should_be_vaild
    if for_clinic? && bookable
      errors.add(:vet_id, 'Vet is invalid') unless bookable.vet_ids.include?(vet_id)
      errors.add(:vet_id, 'Vet is required') if vet_id.blank?
    else
      self.vet_id = nil
    end
  end

  def service_ids_should_be_valid
    if for_clinic?
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

  def set_end_at
    return if vet_id.blank? || vet.nil?
    self.end_at = start_at + vet.session_duration.minutes
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
    self.total_price = cart_items.sum(&:price)
  end
end
