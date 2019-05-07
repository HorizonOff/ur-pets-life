class Wishlist < ApplicationRecord
  belongs_to :user
  belongs_to :item, -> { with_deleted }
end
