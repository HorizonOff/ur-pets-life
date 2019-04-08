json.extract! order_item, :id, :order_id, :item_id, :Quantity, :Unit_Price, :Total_Price, :created_at, :updated_at
json.url order_item_url(order_item, format: :json)
