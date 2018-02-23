class Favorite < ApplicationRecord
  belongs_to :user
  belongs_to :favoritable, polymorphic: true

  validates :favoritable_id, uniqueness: { scope: %i[favoritable_type user_id],
                                           message: 'Object is already in favorite' }
  validate :favoritable_type_should_be_valid

  scope :clinics, -> { where(favoritable_type: 'Clinic') }
  scope :vets, -> { where(favoritable_type: 'Vet') }
  scope :day_care_centres, -> { where(favoritable_type: 'DayCareCentre') }
  scope :grooming_centres, -> { where(favoritable_type: 'GroomingCentre') }
  scope :trainers, -> { where(favoritable_type: 'Trainer') }
  scope :additional_services, -> { where(favoritable_type: 'AdditionalService') }

  ALLOWED_TYPES = %w[Clinic Vet DayCareCentre GroomingCentre Trainer AdditionalService].freeze

  private

  def favoritable_type_should_be_valid
    errors.add(:favoritable_type, 'Favoritable type is invalid') unless favoritable_type.in?(ALLOWED_TYPES)
  end
end
