class ServiceDetail < ApplicationRecord
  validates :price, presence: { message: 'Price is required' }

  belongs_to :service_type, -> { with_deleted }
  belongs_to :pet_type

  has_and_belongs_to_many :appointments

  acts_as_paranoid
end
