class Item < ApplicationRecord
  mount_uploader :picture, PhotoUploader
  belongs_to :item_brand, optional: true
  has_many :wishlists
  has_many :shopping_cart_items
  has_many :order_items
  has_many :item_reviews
  belongs_to :item_category, optional: true
  belongs_to :pet_type, optional: true 
end
