class DayCareCentre < ApplicationRecord
  include ServiceCentreConcern

  has_and_belongs_to_many :service_options
  has_many :service_types, as: :serviceable
end
