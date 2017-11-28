class Breed < ApplicationRecord
  enum pet_category: %i[cat dog]
end
