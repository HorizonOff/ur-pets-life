class Trainer < ApplicationRecord
  include ServiceCentreConcern

  has_and_belongs_to_many :pet_types
  has_and_belongs_to_many :specializations
  has_many :qualifications, as: :skill, inverse_of: :skill, dependent: :destroy
  has_many :service_types, as: :serviceable, dependent: :destroy

  accepts_nested_attributes_for :qualifications, allow_destroy: true
end
