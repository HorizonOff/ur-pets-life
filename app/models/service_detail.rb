class ServiceDetail < ApplicationRecord
  validates :price, presence: { message: 'Price is required' }

  belongs_to :service_type
  belongs_to :pet_type
end
