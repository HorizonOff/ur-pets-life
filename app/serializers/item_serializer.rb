class ItemSerializer < ActiveModel::Serializer
  attributes :id, :picture, :name, :price, :discount, :description, :weight, :unit, :rating, :review_count, :avg_rating, :quantity, :short_description, :unit_price
end
