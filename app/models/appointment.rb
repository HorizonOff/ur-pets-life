class Appointment < ApplicationRecord
  include CalendarValidationConcern

  STATUS_OPTIONS = %i[pending accepted rejected canceled].freeze
  enum status: STATUS_OPTIONS

  belongs_to :user, -> { with_deleted }
  belongs_to :bookable, -> { with_deleted }, polymorphic: true
  belongs_to :admin, -> { with_deleted }, optional: true
  belongs_to :vet, -> { with_deleted }, optional: true
  belongs_to :calendar, optional: true
  belongs_to :main_appointment, class_name: 'Appointment', optional: true

  has_many :diagnoses, dependent: :destroy
  has_many :medications, dependent: :destroy
  has_one :next_appointment, class_name: 'Appointment', foreign_key: :main_appointment_id

  has_many :cart_items, dependent: :destroy

  accepts_nested_attributes_for :cart_items
  accepts_nested_attributes_for :medications

  has_many :service_option_details, -> { order(service_option_id: :asc) }, through: :cart_items,
                                                                           source: :serviceable,
                                                                           source_type: 'ServiceOptionDetail'
  has_many :service_option_times, through: :cart_items

  has_many :comments, as: :commentable, dependent: :destroy
  has_many :user_comments, -> { where(writable_type: 'User') }, as: :commentable, class_name: 'Comment'
  has_many :admin_comments, -> { where(writable_type: 'Admin') }, as: :commentable, class_name: 'Comment'
  has_one :last_comment, -> { order(id: :desc) }, as: :commentable, class_name: 'Comment'

  has_and_belongs_to_many :pets, -> { with_deleted }

  after_initialize :set_defaults

  before_validation :set_start_at, :set_end_at, :set_calendar, :set_admin, :set_number_of_days, on: :create
  before_validation :delete_medications, on: :update

  validates :start_at, presence: { message: 'Date and time are required' }
  validate :vet_id_should_be_vaild, :pet_ids_should_be_valid, :service_ids_should_be_valid, :time_should_be_valid,
           :appointment_overlaps, :dates_should_be_valid

  validates :number_of_days, presence: { message: 'Number of days is required' }, if: :day_care_or_boarding?

  after_validation :set_total_price, on: :create
  after_commit :send_notification, on: :update
  after_commit :send_email, on: :create

  acts_as_paranoid

  scope :past, -> { where('start_at < ?', Time.current).order(start_at: :desc) }
  scope :upcoming, -> { where('start_at > ?', Time.current).order(start_at: :asc) }
  scope :for_clinic, -> { where(bookable_type: 'Clinic') }
  scope :without_rejected, -> { where(status: %i[pending accepted]) }
  scope :overlapsing, (lambda do |id, start_at, end_at|
    without_rejected.where.not(id: id).where('(start_at < :end AND end_at >= :end) OR
                                              (start_at <= :start AND end_at > :start) OR
                                              (start_at >= :start AND end_at <= :end)', start: start_at, end: end_at)
  end)
  scope :msh_members, (lambda do
    joins("LEFT OUTER JOIN day_care_centres ON appointments.bookable_id = day_care_centres.id
          AND appointments.bookable_type = 'DayCareCentre'")
    .joins("LEFT OUTER JOIN boardings ON appointments.bookable_id = boardings.id
           AND appointments.bookable_type = 'Boarding'")
    .joins("LEFT OUTER JOIN grooming_centres ON appointments.bookable_id = grooming_centres.id
           AND appointments.bookable_type = 'GroomingCentre'")
    .where('day_care_centres.name ILIKE :msh OR boardings.name ILIKE :msh OR grooming_centres.name ILIKE :msh',
           msh: '%My Second Home%')
  end)

  def for_clinic?
    @for_clinic ||= bookable_type == 'Clinic'
  end

  def for_grooming?
    @for_grooming ||= bookable_type == 'GroomingCentre'
  end

  def for_day_care?
    @for_day_care ||= bookable_type == 'DayCareCentre'
  end

  def for_boarding?
    @for_boarding ||= bookable_type == 'Boarding'
  end

  def day_care_or_boarding?
    @day_care_or_boarding = for_boarding? || for_day_care?
  end

  def past?
    @past ||= if day_care_or_boarding?
                start_at.end_of_day <= current_time
              else
                start_at <= current_time
              end
  end

  def start_at=(value)
    value = Time.zone.at(value.to_i)
    super
  end

  def can_be_canceled?
    can_be_rejected? || (accepted? && !past?)
  end

  def can_be_rejected?
    @can_be_rejected ||= pending?
  end

  def can_be_accepted?
    pending? && !past?
  end

  def update_counters
    unread_comments_count_by_user = admin_comments.where(read_at: nil).count
    unread_comments_count_by_admin = user_comments.where(read_at: nil).count
    update_columns(unread_comments_count_by_user: unread_comments_count_by_user,
                   unread_comments_count_by_admin: unread_comments_count_by_admin)
  end

  private

  def send_notification
    return unless 'status'.in?(saved_changes.keys)
    user.notifications.create(appointment: self, message: 'Your appointment was ' + status)
  end

  def send_email
    AppointmentMailer.send_email_to_establishment(self).deliver
  end

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
      self.cart_items = []
    else
      check_services_count
    end
  end

  def dates_should_be_valid
    return unless for_day_care?
    errors.add(:dates, 'Should be at least 1 date in booking') if dates.blank?
  end

  def set_number_of_days
    return unless for_day_care?
    self.number_of_days = dates.length
  end

  def check_services_count
    errors.add(:service_detail_ids, 'Booking service is required') if service_detail_ids.empty?
    return if bookable_type == 'Clinic' || bookable_type == 'GroomingCentre'
    cart_items_for_check = cart_items.select { |ci| ci.serviceable_type == 'ServiceDetail' }.group_by(&:pet_id)
    services_valid = cart_items_for_check.each_value do |ci|
      break false if ci.size > 1
    end
    errors.add(:service_detail_ids, 'Should be only 1 service for pet in booking') unless services_valid
  end

  def pet_ids_should_be_valid
    user_pet_ids = user.pets.owned.pluck(:id)
    if for_clinic?
      another_ids = pet_ids - user_pet_ids
      errors.add(:pet_ids, 'Pets are invalid') if another_ids.present?
    else
      service_pet_ids = cart_items.map(&:pet_id).uniq.compact
      another_ids = service_pet_ids - user_pet_ids
      return errors.add(:pet_ids, 'Pets are invalid') if another_ids.present?
      self.pet_ids = service_pet_ids
    end
  end

  def set_calendar
    return if !for_clinic? || calendar_id.present? || vet_id.blank?
    current_vet_calendar = vet.calendars.where('start_at <= ? AND end_at >= ?', start_at, end_at).first
    self.calendar = current_vet_calendar if current_vet_calendar
  end

  def delete_medications
    medications.where('id IS NOT NULL').delete_all
  end

  def set_start_at
    return if !for_day_care? || dates.blank?
    self.start_at = Time.zone.parse(dates.first).to_i
  end

  def set_end_at
    if for_clinic?
      set_end_at_for_clinic
    elsif for_grooming?
      set_end_at_for_grooming
    elsif for_day_care?
      set_end_at_for_day_care
    else
      set_end_at_for_boarding
    end
  end

  def set_end_at_for_clinic
    return if vet_id.blank? || vet.nil?
    self.end_at = start_at + vet.session_duration.minutes
  end

  def set_end_at_for_grooming
    self.end_at = start_at + 30.minutes
  end

  def set_end_at_for_day_care
    return if dates.blank?
    self.end_at = Time.zone.parse(dates.last)
  end

  def set_end_at_for_boarding
    return if number_of_days.blank?
    self.end_at = start_at + (number_of_days - 1).days
  end

  def appointment_overlaps
    return if !for_clinic? || vet_id.blank?
    errors.add(:base, 'Appointment is overlapsing with other appointment') unless overlapsing_appointments.count.zero?
  end

  def overlapsing_appointments
    vet.appointments.overlapsing(id, start_at, end_at)
  end

  def set_total_price
    return self.total_price = vet.consultation_fee if vet_id.present?
    self.total_price = cart_items.sum(&:total_price)
  end

  def service_detail_ids
    @service_detail_ids ||= cart_items.select { |ca| ca.serviceable_type == 'ServiceDetail' }.map(&:serviceable_id)
  end
end
