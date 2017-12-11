class Clinic < ApplicationRecord
  include ServiceCentreConcern
  has_and_belongs_to_many :specializations
  has_many :vets
end
