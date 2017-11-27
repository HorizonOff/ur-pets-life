class Pet < ApplicationRecord
  TYPE_OPTIONS = %i[cat dog other].freeze
  SEX_OPTIONS = %i[male female].freeze
  enum category: TYPE_OPTIONS
  enum sex: SEX_OPTIONS

  belongs_to :user, optional: true
  belongs_to :breed, optional: true
  validates_presence_of :name, :birthday, message: 'is required'
  validates_presence_of :category, :sex, message: 'is invalid'

  validate :sex_should_be_valid, :category_should_be_valid, :breed_should_be_valid

  def sex=(value)
    super value
    @sex_backup = nil
  rescue ArgumentError => exception
    error_message = 'is not a valid sex'
    raise unless exception.message.include?(error_message)
    @sex_backup = value
    self[:sex] = nil
  end

  def category=(value)
    super value
    @category_backup = nil
  rescue ArgumentError => exception
    error_message = 'is not a valid category'
    raise unless exception.message.include?(error_message)
    @category_backup = value
    self[:category] = nil
  end

  private

  def sex_should_be_valid
    return unless @sex_backup
    self.sex ||= @sex_backup
    error_message = 'is invalid'
    errors.add(:sex, error_message)
  end

  def category_should_be_valid
    return unless @category_backup
    self.category ||= @category_backup
    error_message = 'is invalid'
    errors.add(:category, error_message)
  end

  def breed_should_be_valid
    return if breed_id.nil?
    errors.add(:breed_id, 'is invalid') unless Breed.exists?(pet_category: category, id: breed_id)
  end
end
