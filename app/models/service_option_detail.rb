class ServiceOptionDetail < ApplicationRecord
  belongs_to :service_option
  belongs_to :service_optionable, -> { with_deleted }, polymorphic: true

  has_many :cart_items, as: :serviceable

  delegate :name, :description, to: :service_option

  acts_as_paranoid
end
