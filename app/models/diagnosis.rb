class Diagnosis < ApplicationRecord
  belongs_to :appointment

  has_many :recipes, dependent: :destroy

  validates :pet_id, uniqueness: { scope: :appointment_id, message: 'Diagnosis already exist' }
  validates :condition, :message, presence: true
  validate :appointment_id_should_be_valid
  before_save :squish_instruction

  accepts_nested_attributes_for :recipes, allow_destroy: true

  private

  def appointment_id_should_be_valid
    errors.add(:appointment_id, 'Appointment is invalid') unless appointment.for_clinic?
  end

  def squish_instruction
    self.message = message.squish
  end
end
