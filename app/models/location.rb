class Location < ApplicationRecord
  BUILDING_OPTIONS = %i[building villa].freeze
  enum building_type: BUILDING_OPTIONS
  belongs_to :place, polymorphic: true

  validate :building_type_should_be_valid

  geocoded_by :address
  after_validation :geocode, if: ->(obj) { obj.address.present? && (obj.latitude.empty? || obj.longitude.empty?) }

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

  def building_type_should_be_valid
    return unless @building_type_backup
    self.building_type ||= @building_type_backup
    error_message = 'Building type is invalid'
    errors.add(:building_type, error_message)
  end
end
