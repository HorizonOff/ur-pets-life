class CartItem < ApplicationRecord
  belongs_to :pet, optional: true
  belongs_to :appointment
  belongs_to :serviceable, -> { with_deleted }, polymorphic: true

  before_validation :set_price, on: :create

  validate :pet_should_be_valid, :weight_should_be_valid

  def set_price
    self.price = serviceable.price
  end

  private

  def pet_should_be_valid
    if serviceable_type == 'ServiceOptionDetail'
      self.pet_id = nil
    elsif pet.pet_type_id != serviceable.pet_type_id
      errors.add(:pet, 'Wrong pet for service')
    end
  end

  def weight_should_be_valid
    return if serviceable_type == 'ServiceOptionDetail' || appointment.for_clinic? || appointment.bookable_type == 'GroomingCentre'
    errors.add(:pet, 'Too small room for pet') if pet.weight > serviceable.weight
  end
end
