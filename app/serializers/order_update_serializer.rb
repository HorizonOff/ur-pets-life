class OrderUpdateSerializer < ActiveModel::Serializer
  attributes :id, :Subtotal, :Delivery_Charges, :Vat_Charges, :Total, :Delivery_Date, :Order_Notes, :IsCash,
             :shipmenttime, :RedeemPoints, :earned_points, :company_discount, :is_user_from_company, :code_discount,
             :driver_id

  belongs_to :location
  has_many :order_items
end

