class LocationSerializer < ActiveModel::Serializer
  attributes :latitude, :longitude, :country, :city, :street, :building_type, :building_name, :unit_number, :villa_number
end
