class UserSerializer < BaseMethodsSerializer
  type 'user'

  attributes :first_name, :last_name, :email, :mobile_number, :birthday, :gender
  has_one :location, key: :location_attributes

  def gender
    User.genders[object.gender]
  end
end
