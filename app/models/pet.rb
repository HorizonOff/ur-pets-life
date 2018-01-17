class Pet < ApplicationRecord
  SEX_OPTIONS = %i[male female].freeze
  enum sex: SEX_OPTIONS

  belongs_to :user, optional: true
  belongs_to :breed, optional: true
  belongs_to :pet_type
  has_many :vaccine_types, through: :pet_type
  has_many :vaccinations, dependent: :destroy
  has_many :pictures, dependent: :destroy
  has_many :appointments, dependent: :destroy
  has_many :past_clinic_appointments, -> { where(bookable_type: 'Clinic').past }, class_name: 'Appointment'

  has_one :location, as: :place, inverse_of: :place
  reverse_geocoded_by 'locations.latitude', 'locations.longitude'

  delegate :address, to: :location

  accepts_nested_attributes_for :location, update_only: true
  accepts_nested_attributes_for :vaccinations, allow_destroy: true
  accepts_nested_attributes_for :pictures, allow_destroy: true

  validates_presence_of :name, message: 'Name is required', if: :not_found?
  validates_presence_of :birthday, message: 'Birthday is required', if: :not_found?
  validates_presence_of :sex, message: 'Sex is required', if: :not_found?
  validates_presence_of :additional_type, message: 'Type is required', if: :additional_type_required?

  validates_presence_of :description, message: 'Short description is required', if: :lost_or_found?
  validates_presence_of :mobile_number, message: 'Mobile number is required', if: :lost_or_found?

  validate :sex_should_be_valid, :breed_should_be_valid, :lost_and_found_should_be_vaild
  # validates :avatar, file_size: { less_than: 1.megabyte }
  mount_uploader :avatar, PhotoUploader

  has_paper_trail only: [:weight], skip: [:avatar]

  before_save :remove_location, if: ->(obj) { obj.changed_attributes.keys.include?('lost_at') && obj.lost_at.blank? }

  scope :alphabetical_order, -> { order(description: :asc) }
  scope :for_adoption,       -> { where(is_for_adoption: true, lost_at: nil) }
  scope :lost,               -> { where.not(lost_at: nil) }
  scope :found,              -> { where.not(found_at: nil) }
  scope :owned,              -> { where(found_at: nil) }
  scope :lost_or_found,      -> { lost.or(found) }
  scope :can_be_lost,        -> { where(lost_at: nil, found_at: nil) }
  scope :can_be_adopted,     -> { where(lost_at: nil, found_at: nil, is_for_adoption: false) }

  def sex=(value)
    value = value.to_i if value.in?(%w[0 1])
    super value
    @sex_backup = nil
  rescue ArgumentError => exception
    error_message = 'is not a valid sex'
    raise unless exception.message.include?(error_message)
    @sex_backup = value
    self[:sex] = nil
  end

  def is_lost=(value)
    return unless value.in? [false, 'false']
    self.lost_at = nil
    self.mobile_number = nil
    self.description = nil
    self.additional_comment = nil
  end

  def birthday=(value)
    value = Time.zone.at(value.to_i)
    super
  end

  def lost_at=(value)
    value = Time.zone.at(value.to_i)
    super
  end

  def found_at=(value)
    value = Time.zone.at(value.to_i)
    super
  end

  def pet_type_is_additional?
    @pet_type_is_additional ||= pet_type.is_additional_type?
  end

  private

  def remove_location
    location.destroy if location.present?
  end

  def additional_type_required?
    pet_type_is_additional?
  end

  def not_found?
    found_at.blank?
  end

  def lost_or_found?
    lost_at.present? || found_at.present?
  end

  def sex_should_be_valid
    return unless @sex_backup
    self.sex ||= @sex_backup
    error_message = 'Sex is invalid'
    errors.add(:sex, error_message)
  end

  def breed_should_be_valid
    return if (breed_id.nil? && pet_type_is_additional?) || found_at.present?
    errors.add(:breed_id, 'Breed is invalid') unless Breed.exists?(pet_type_id: pet_type_id, id: breed_id)
  end

  def lost_and_found_should_be_vaild
    errors.add(:lost_at, "Pet can't be lost and found at the same time") if lost_at.present? && found_at.present?
  end
end
