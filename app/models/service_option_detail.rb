class ServiceOptionDetail < ApplicationRecord
  belongs_to :service_option
  belongs_to :service_optionable, -> { with_deleted }, polymorphic: true

  has_many :cart_items, as: :serviceable
  has_many :service_option_times, dependent: :destroy, inverse_of: :service_option_detail

  delegate :name, :description, to: :service_option

  accepts_nested_attributes_for :service_option_times, allow_destroy: true

  validates :service_option_times, length: { minimum: 1, message: 'Should be at least 1 time slot' }
  acts_as_paranoid
end
