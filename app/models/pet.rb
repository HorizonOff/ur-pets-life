class Pet < ApplicationRecord
  SEX_OPTIONS = %i[male female].freeze
  enum sex: SEX_OPTIONS

  belongs_to :user, optional: true
  belongs_to :breed, optional: true
  belongs_to :pet_type
  has_many :vaccine_types, through: :pet_type
  has_many :vaccinations
  has_many :pictures

  accepts_nested_attributes_for :vaccinations, allow_destroy: true
  accepts_nested_attributes_for :pictures, allow_destroy: true

  validates_presence_of :name, message: 'Name is required'
  validates_presence_of :birthday, message: 'Birthday is required'
  validates_presence_of :sex, message: 'Sex is required'
  validates_presence_of :additional_type, message: 'Type is required', if: :additiona_type_required?

  validate :sex_should_be_valid, :breed_should_be_valid

  mount_uploader :avatar, PhotoUploader

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

  private

  def additiona_type_required?
    pet_type_is_additional?
  end

  def pet_type_is_additional?
    @pet_type_is_additional ||= pet_type.is_additional_type?
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
end
