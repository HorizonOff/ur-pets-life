class ServiceDetail < ApplicationRecord
  validates :price, presence: { message: 'Price is required' }

  belongs_to :service_type, -> { with_deleted }
  belongs_to :pet_type

  has_many :cart_items, as: :serviceable

  delegate :name, :description, to: :service_type

  scope :with_pet_types, ->(pet_type_ids) { where(pet_type_id: pet_type_ids) }

  acts_as_paranoid
end
