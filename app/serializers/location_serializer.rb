class LocationSerializer < ActiveModel::Serializer
  attributes :id, :latitude, :longitude, :city, :area, :street, :building_type, :comment, :name

  attribute :building_name, if: -> { object.building? }
  attribute :unit_number, if: -> { object.building? }
  attribute :villa_number, if: -> { object.villa? }

  def building_type
    Location.building_types[object.building_type]
  end
end
