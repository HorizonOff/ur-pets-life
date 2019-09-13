class OrderSerializer < ActiveModel::Serializer
  attributes :id, :Delivery_Date, :Order_Notes, :Delivery_Charges, :Vat_Charges, :Subtotal, :Total, :IsCash,
             :Order_Status, :Payment_Status
end
