class Appointment < ApplicationRecord
  belongs_to :user
  belongs_to :bookable, polymorphic: true
  belongs_to :pet
  belongs_to :vet, optional: true

  validates :booked_at, presence: { message: 'Date and time are required' }
  validate :vet_id_should_be_vaild, :pet_id_should_be_valid

  private

  def vet_id_should_be_vaild
    if bookable_type == 'Clinic' && bookable
      errors.add(:vet_id, 'Vet is invalid') unless bookable.vet_ids.include?(vet_id)
      errors.add(:vet_id, 'Vet is required') if vet_id.blank?
    else
      self.vet_id = nil
    end
  end

  def pet_id_should_be_valid
    errors.add(:pet_id, 'Pet is invalid') unless user.pet_ids.include?(pet_id)
  end
end
