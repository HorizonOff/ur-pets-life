class Clinic < ApplicationRecord
  include ServiceCentreConcern
  has_and_belongs_to_many :specializations
  has_many :vets, dependent: :destroy

  has_one :schedule, as: :schedulable, inverse_of: :schedulable
  accepts_nested_attributes_for :schedule, update_only: true
end
