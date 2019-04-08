json.extract! order, :id, :references, :references, :Delivery_Date, :Order_Notes, :Delivery_Charges, :Vat_Charges, :Total, :IsCash, :Order_Status, :Payment_Status, :created_at, :updated_at
json.url order_url(order, format: :json)
