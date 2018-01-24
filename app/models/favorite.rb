class Favorite < ApplicationRecord
  belongs_to :user
  belongs_to :favoritable, polymorphic: true

  validates :favoritable_id, uniqueness: { scope: %i[favoritable_type user_id],
                                           message: 'Object is already in favorite' }
end
