class CartItem < ApplicationRecord
  belongs_to :appointment
  belongs_to :service_detail

  before_validation :set_price, on: :create

  def set_price
    self.price = service_detail.price
  end
end
