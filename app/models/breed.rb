class Breed < ApplicationRecord
  belongs_to :pet_type
  has_many :pets
end
