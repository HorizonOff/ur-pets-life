class Vaccination < ApplicationRecord
  belongs_to :vaccine_type
  belongs_to :pet
  validates_presence_of :done_at, message: 'Date is required'
  validate :vaccine_type_should_be_valid

  mount_uploader :picture, PhotoUploader

  private

  def vaccine_type_should_be_valid
    errors.add(:vaccie_type_id, 'Vaccine type is invalid') unless pet.category.in?(vaccine_type.pet_categories)
  end
end
