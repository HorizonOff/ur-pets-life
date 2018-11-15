class LocationSerializer < ActiveModel::Serializer
  attributes :latitude, :longitude, :city, :area, :street, :building_type, :comment

  attribute :building_name, if: -> { object.building? }
  attribute :unit_number, if: -> { object.building? }
  attribute :villa_number, if: -> { object.villa? }

  def building_type
    Location.building_types[object.building_type]
  end
end
