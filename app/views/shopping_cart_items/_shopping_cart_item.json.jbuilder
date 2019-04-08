json.extract! shopping_cart_item, :id, :IsRecurring, :Interval, :quantity, :item_id, :user_id, :created_at, :updated_at
json.url shopping_cart_item_url(shopping_cart_item, format: :json)
