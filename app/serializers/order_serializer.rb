class OrderSerializer < ActiveModel::Serializer
  attributes :id, :references, :references, :Delivery_Date, :Order_Notes, :Delivery_Charges, :Vat_Charges, :Total, :IsCash, :Order_Status, :Payment_Status
end
