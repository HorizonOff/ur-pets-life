json.extract! item_review, :id, :user_id, :item_id, :rating, :comment, :created_at, :updated_at
json.url item_review_url(item_review, format: :json)
