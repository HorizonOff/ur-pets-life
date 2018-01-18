class ServiceType < ApplicationRecord
  validates :name, presence: { message: 'Name is required' }

  belongs_to :serviceable, polymorphic: true
  has_many :service_details, dependent: :destroy

  accepts_nested_attributes_for :service_details, allow_destroy: true

  def default_set(except_ids = [])
    pet_types = PetType.where.not(id: except_ids)
    pet_types.map { |pt| service_details.build(pet_type: pt) }
  end

  def service_details_with_blanks
    default_set(service_details.pluck(:pet_type_id))
  end
end
