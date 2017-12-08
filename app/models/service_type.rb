class ServiceType < ApplicationRecord
  validates :name, presence: { message: 'Name is required' }

  belongs_to :serviceable, polymorphic: true
  has_many :service_details

  accepts_nested_attributes_for :service_details, allow_destroy: true
end
