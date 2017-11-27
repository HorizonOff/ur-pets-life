class Breed < ApplicationRecord
  enum status: %i[cat dog]
end
