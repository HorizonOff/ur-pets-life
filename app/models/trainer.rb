class Trainer < ApplicationRecord
  include ServiceCentreConcern

  has_and_belongs_to_many :specializations
  has_many :qualifications, as: :skill
  has_many :service_types, as: :serviceable

  accepts_nested_attributes_for :qualifications, allow_destroy: true
  accepts_nested_attributes_for :service_types, allow_destroy: true
end
