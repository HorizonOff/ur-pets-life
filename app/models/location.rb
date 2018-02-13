class Location < ApplicationRecord
  BUILDING_OPTIONS = %i[building villa].freeze
  enum building_type: BUILDING_OPTIONS
  belongs_to :place, polymorphic: true

  validate :building_type_should_be_valid, :attributes_should_be_valid

  after_initialize :set_defaults

  geocoded_by :address
  after_validation :geocode, if: :should_geocode?

  acts_as_paranoid

  def address
    address_fields = [city, area, street]
    address_fields += building? ? [building_name, unit_number] : [villa_number]
    address_fields.reject!(&:blank?)
    address_fields.compact.join(', ')
  end

  def building_type=(value)
    value = value.to_i if value.in?(%w[0 1])
    super value
    @building_type_backup = nil
  rescue ArgumentError => exception
    error_message = 'is not a valid building_type'
    raise unless exception.message.include?(error_message)
    @building_type_backup = value
    self[:building_type] = nil
  end

  private

  def set_defaults
    return if persisted?
    self.building_type ||= :building
  end

  def building_type_should_be_valid
    return unless @building_type_backup
    self.building_type ||= @building_type_backup
    error_message = 'Building type is invalid'
    errors.add(:building_type, error_message)
  end

  def attributes_should_be_valid
    return errors.add(:city, 'Location is required') if place_type == 'Pet' && coardinates_blank? && fields_blank?
    errors.add(:city, 'Location is required') if fields_blank?
  end

  def fields_blank?
    city.blank? && area.blank? && street.blank? && building_name.blank?
  end

  def coardinates_blank?
    @coardinates_blank ||= latitude.blank? || longitude.blank?
  end

  def should_geocode?
    address.present? && coardinates_blank?
  end

  def changed_some_attributes?
    %w[city street area].any? { |attr| attr.in? changed_attributes.keys }
  end

  def coardinates_the_same?
    %w[latitude longitude].none? { |attr| attr.in? changed_attributes.keys }
  end
end
