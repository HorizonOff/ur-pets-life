class VaccineType < ApplicationRecord
  validates_presence_of :name
  validates_presence_of :pet_categories
end
