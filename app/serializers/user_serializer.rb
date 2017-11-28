class UserSerializer < ActiveModel::Serializer
  type 'user'

  attributes :first_name, :last_name, :email, :phone_number
  has_one :location, key: :location_attributes
end
