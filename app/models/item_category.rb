class ItemCategory < ApplicationRecord
  mount_uploader :picture, PhotoUploader
  has_and_belongs_to_many :pet_types
  has_and_belongs_to_many :item_brands
  has_and_belongs_to_many :items
end
