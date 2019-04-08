json.extract! wishlist, :id, :user_id, :item_id, :created_at, :updated_at
json.url wishlist_url(wishlist, format: :json)
