module AdminPanel
  class ItemSerializer < ActiveModel::Serializer
    attributes :id, :supplier_code, :name, :price, :unit_price, :discount, :weight, :description, :unit, :avg_rating,
               :quantity, :short_description, :picture, :buying_price, :actions
  end
end
