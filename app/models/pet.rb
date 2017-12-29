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
  has_many :past_clinic_appointments, -> { where(bookable_type: 'Clinic').past }, class_name: Appointment

  has_one :location, through: :user
  reverse_geocoded_by 'locations.latitude', 'locations.longitude'

  accepts_nested_attributes_for :vaccinations, allow_destroy: true
  accepts_nested_attributes_for :pictures, allow_destroy: true

  validates_presence_of :name, message: 'Name is required'
  validates_presence_of :birthday, message: 'Birthday is required'
  validates_presence_of :sex, message: 'Sex is required'
  validates_presence_of :additional_type, message: 'Type is required', if: :additiona_type_required?

  validate :sex_should_be_valid, :breed_should_be_valid, :lost_and_found_should_be_vaild
  # validates :avatar, file_size: { less_than: 1.megabyte }
  mount_uploader :avatar, PhotoUploader

  has_paper_trail only: [:weight], skip: [:avatar]

  scope :alphabetical_order, -> { order(name: :asc) }
  scope :for_adoption,       -> { where(is_for_adoption: true, lost_at: nil) }
  scope :lost,               -> { where.not(lost_at: nil) }
  scope :found,              -> { where.not(found_at: nil) }
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
    if value.in? [true, 'true']
      self.lost_at ||= Time.now
    else
      self.lost_at = nil
    end
  end

  def is_lost
    lost_at.present?
  end

  def is_found=(value)
    if value.in? [true, 'true']
      self.found_at ||= Time.now
    else
      self.lost_at = nil
    end
  end

  def is_found
    found_at.present?
  end

  def pet_type_is_additional?
    @pet_type_is_additional ||= pet_type.is_additional_type?
  end

  private

  def additiona_type_required?
    pet_type_is_additional?
  end

  def sex_should_be_valid
    return unless @sex_backup
    self.sex ||= @sex_backup
    error_message = 'Sex is invalid'
    errors.add(:sex, error_message)
  end

  def breed_should_be_valid
    return if breed_id.nil? && pet_type_is_additional?
    errors.add(:breed_id, 'Breed is invalid') unless Breed.exists?(pet_type_id: pet_type_id, id: breed_id)
  end

  def lost_and_found_should_be_vaild
    errors.add(:lost_at, "Pet can't be lost and found at the same time") if lost_at.present? && found_at.present?
  end
end
