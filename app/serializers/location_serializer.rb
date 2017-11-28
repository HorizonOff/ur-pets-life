class LocationSerializer < ActiveModel::Serializer
  attributes :latitude, :longitude, :city, :area, :street, :building_type, :building_name, :unit_number, :villa_number
end
