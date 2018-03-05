class CartItem < ApplicationRecord
  belongs_to :pet, optional: true
  belongs_to :appointment
  belongs_to :serviceable, -> { with_deleted }, polymorphic: true

  before_validation :set_price, on: :create

  def set_price
    self.price = service_detail.price
  end
end
