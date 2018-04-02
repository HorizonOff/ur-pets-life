class Pet < ApplicationRecord
  enum sex: User::GENDER_OPTIONS

  belongs_to :user, -> { with_deleted }, optional: true
  belongs_to :breed, optional: true
  belongs_to :pet_type

  has_many :vaccine_types, through: :pet_type
  has_many :vaccinations, -> { order(done_at: :desc) }, inverse_of: :pet, dependent: :destroy
  has_many :pictures, inverse_of: :pet, dependent: :destroy
  has_many :diagnoses
  has_and_belongs_to_many :appointments

  has_one :location, as: :place, inverse_of: :place, dependent: :destroy
  has_one :user_location, through: :user, source: :location
  reverse_geocoded_by 'locations.latitude', 'locations.longitude'

  delegate :address, to: :location, allow_nil: true

  accepts_nested_attributes_for :location, update_only: true
  accepts_nested_attributes_for :vaccinations, allow_destroy: true
  accepts_nested_attributes_for :pictures, allow_destroy: true

  validates_presence_of :location, message: 'Locations is required', if: :lost_or_found?
  validates_presence_of :name, message: 'Name is required', if: :owned?
  validates_presence_of :birthday, message: 'Birthday is required', if: :owned?
  validates_presence_of :sex, message: 'Sex is required', if: :owned?
  validates_presence_of :weight, message: 'Weight is required', if: :owned?
  validates_presence_of :additional_type, message: 'Type is required', if: :additional_type_required?

  validates_presence_of :description, message: 'Short description is required', if: :lost_or_found?
  validates :mobile_number, format: { with: /\A\+\d+\z/, message: 'Mobile Number is invalid' },
                            presence: { message: 'Mobile number is required' },
                            length: { within: 11..13, too_short: 'Mobile number should contain at least 10 symbols',
                                      too_long: 'Mobile number should contain not more than 12 symbols' },
                            if: :lost_or_found?

  validates :municipality_tag, format: { with: /\A[A-Z]\d{5,5}\s\d{4,4}\z/, message: 'Municipality Tag is invalid' },
                               allow_blank: true
  #                             presence: { message: 'Municipality Tag is required' }, if: :owned_main_type_pet?

  validates :microchip, format: { with: /\A\d+\z/, message: 'Microchip is invalid' },
                        length: { within: 12..20, too_short: 'Microchip should contain at least 12 symbols',
                                  too_long: 'Microchip should contain not more than 20 symbols' },
                        allow_blank: true
  #                      presence: { message: 'Microchip is required' }, if: :owned_main_type_pet?

  validate :sex_should_be_valid, :breed_should_be_valid, :lost_and_found_should_be_vaild, :data_should_be_valid
  # validates :avatar, file_size: { less_than: 1.megabyte }
  mount_uploader :avatar, PhotoUploader

  acts_as_paranoid

  has_paper_trail only: [:weight], skip: [:avatar]

  before_save :remove_location, if: ->(obj) { obj.changed_attributes.keys.include?('lost_at') && obj.lost_at.blank? }

  after_update :send_lost_notification

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
    value = Time.zone.at(value.to_i) if value.present?
    super
  end

  def found_at=(value)
    value = Time.zone.at(value.to_i)
    super
  end

  def pet_type_is_additional?
    @pet_type_is_additional ||= pet_type.is_additional_type?
  end

  def owned?
    @owned ||= found_at.blank?
  end

  def lost?
    @lost ||= lost_at.present?
  end

  def found?
    @found ||= found_at.present?
  end

  def lost_or_found?
    @lost_or_found ||= lost? || found?
  end

  private

  def send_lost_notification
    return if saved_changes.transform_values(&:second)[:lost_at].blank?
    users_for_lost_notifications.each do |u|
      send_notification_to_user(u)
    end
  end

  def users_for_lost_notifications
    User.where.not(id: user_id).joins(:location).near([location.latitude, location.longitude], 10, units: :km)
  end

  def send_notification_to_user(user)
    user.notifications.create(pet_id: id, message: "#{description} was lost in your area")
  end

  def owned_main_type_pet?
    @owned_main_type_pet ||= owned? && !pet_type_is_additional?
  end

  def remove_location
    location.really_destroy! if location.present?
  end

  def additional_type_required?
    @additional_type_required ||= owned? && pet_type_is_additional?
  end

  def sex_should_be_valid
    return unless @sex_backup
    self.sex ||= @sex_backup
    error_message = 'Sex is invalid'
    errors.add(:sex, error_message)
  end

  def data_should_be_valid
    if owned_main_type_pet?
      self.additional_type = nil
    else
      self.microchip = nil
      self.municipality_tag = nil
    end
  end

  def breed_should_be_valid
    return if (breed_id.nil? && pet_type_is_additional?) || found_at.present?
    errors.add(:breed_id, 'Breed is invalid') unless Breed.exists?(pet_type_id: pet_type_id, id: breed_id)
  end

  def lost_and_found_should_be_vaild
    errors.add(:lost_at, "Pet can't be lost and found at the same time") if lost_at.present? && found_at.present?
  end
end
