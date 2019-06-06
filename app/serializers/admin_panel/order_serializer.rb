module AdminPanel
  class OrderSerializer < ActiveModel::Serializer
    attributes :id, :user_id, :location_id, :Delivery_Date, :Subtotal, :is_viewed, :Order_Notes, :Delivery_Charges,
               :Vat_Charges, :Total, :IsCash, :Order_Status, :order_status_flag, :Payment_Status, :is_pre_recurring,
               :created_at, :actions
  end
end
