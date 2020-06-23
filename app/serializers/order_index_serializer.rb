class OrderIndexSerializer < ActiveModel::Serializer
  attributes :id, :Subtotal, :shipmenttime, :Delivery_Charges, :Vat_Charges, :Total, :Delivery_Date, :Order_Notes,
             :IsCash, :RedeemPoints, :earned_points, :driver_id

  belongs_to :location
  has_many :order_items
end
