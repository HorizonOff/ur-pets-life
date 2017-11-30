class Vaccination < ApplicationRecord
  belongs_to :vaccine_type
  belongs_to :pet
  validates_presence_of :done_at, message: 'Date is required'
  validate :vaccine_type_should_be_valid

  private

  def vaccine_type_should_be_valid
    errors.add(:vaccine_type_id, 'Vaccine type is invalid') unless pet.vaccine_type_ids.include?(vaccine_type_id)
  end
end
