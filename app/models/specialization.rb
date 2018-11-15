class Specialization < ApplicationRecord
  validates :name, presence: { message: 'Name is required' }

  has_and_belongs_to_many :clinics
  has_and_belongs_to_many :vets
  has_and_belongs_to_many :trainers

  scope :for_clinic, -> { where(is_for_trainer: false) }
  scope :for_trainer, -> { where(is_for_trainer: true) }
end
