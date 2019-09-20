class UnregisteredUser < ApplicationRecord
  has_many :orders

  validates :name, presence: { message: 'Name is required' }
  validates :number, uniqueness: true, allow_blank: true
end
