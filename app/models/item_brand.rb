class ItemBrand < ApplicationRecord
  mount_uploader :picture, PhotoUploader
  has_and_belongs_to_many :item_categories
  has_and_belongs_to_many :items, dependent: :destroy

  acts_as_paranoid
end
