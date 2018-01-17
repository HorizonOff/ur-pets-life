class EmergencySerializer < BaseMethodsSerializer
  type 'emergency'
  attributes :name, :address, :mobile_number, :type, :latitude, :longitude

  def type
    object.class.name
  end

  def latitude
    object.location.try(:latitude)
  end

  def longitude
    object.location.try(:longitude)
  end
end
