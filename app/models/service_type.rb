class ServiceType < ApplicationRecord
  validates :name, presence: { message: 'Name is required' }

  belongs_to :serviceable, -> { with_deleted }, polymorphic: true
  has_many :service_details, dependent: :destroy, inverse_of: :service_type
  has_many :cat_services, -> { where(pet_type_id: 1) }, class_name: 'ServiceDetail', inverse_of: :service_type
  has_many :dog_services, -> { where(pet_type_id: 2) }, class_name: 'ServiceDetail', inverse_of: :service_type
  has_many :other_services, -> { where(pet_type_id: 3) }, class_name: 'ServiceDetail', inverse_of: :service_type

  accepts_nested_attributes_for :service_details, allow_destroy: true
  accepts_nested_attributes_for :cat_services, allow_destroy: true
  accepts_nested_attributes_for :dog_services, allow_destroy: true
  accepts_nested_attributes_for :other_services, allow_destroy: true

  acts_as_paranoid

  def default_set(except_ids = [])
    pet_types = PetType.where.not(id: except_ids)
    pet_types.map { |pt| service_details.build(pet_type: pt) }
  end

  def service_details_with_blanks
    default_set(service_details.pluck(:pet_type_id))
  end

  def build_services_relation
    cat_services.build
    dog_services.build
    other_services.build
  end
end
