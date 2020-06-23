class OrderShowSerializer < ActiveModel::Serializer
  attributes :id, :Subtotal, :shipmenttime, :Delivery_Charges, :Vat_Charges, :Total, :Delivery_Date, :Order_Notes,
             :IsCash, :RedeemPoints, :earned_points, :order_status_flag

  belongs_to :location
  belongs_to :user, serializer: ShowOrderUserSerializer
  has_many :order_items
  belongs_to :driver, serializer: DriverSerializer
end
