class DayCareCentre < ApplicationRecord
  include ServiceCentreConcern

  has_and_belongs_to_many :service_options
  has_many :service_types, as: :serviceable

  has_one :schedule, as: :schedulable, inverse_of: :schedulable
  accepts_nested_attributes_for :schedule, update_only: true
end
