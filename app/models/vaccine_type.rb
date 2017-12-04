class VaccineType < ApplicationRecord
  validates_presence_of :name
  has_and_belongs_to_many :pet_types
  has_many :vaccinations
end
