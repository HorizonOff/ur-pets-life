class CartItemSerializer < ActiveModel::Serializer
  attributes :id, :name, :price

  def name
    object.serviceable.name
  end
end
