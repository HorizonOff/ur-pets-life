class PetType < ApplicationRecord
  has_and_belongs_to_many :vaccine_types
  has_and_belongs_to_many :vets
  has_and_belongs_to_many :clinics
  has_and_belongs_to_many :grooming_centres
  has_many :pets
  has_many :breeds

  validates_presence_of :name, message: 'Name is required'
end
