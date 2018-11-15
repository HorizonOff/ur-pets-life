class ItemBrand < ApplicationRecord
  mount_uploader :picture, PhotoUploader
  has_and_belongs_to_many :item_categories
  has_many :items
end
