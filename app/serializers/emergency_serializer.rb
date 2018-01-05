class EmergencySerializer < ActiveModel::Serializer
  type 'emergency'
  attributes :name, :address, :mobile_number, :type, :latitude, :longotude

  def type
    object.class.name
  end

  def address
    object.location.try(:address)
  end

  def latitude
    object.location.try(:latitude)
  end

  def longitude
    object.location.try(:longitude)
  end

  def distance
    object.location.distance_to([scope[:latitude], scope[:longitude]], :km).try(:round, 2) if show_distance?
  end

  private

  def show_distance?
    object.location.present? && scope[:latitude].present? && scope[:longitude].present?
  end
end
