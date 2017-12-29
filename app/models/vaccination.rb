class Vaccination < ApplicationRecord
  belongs_to :vaccine_type
  belongs_to :pet
  validates_presence_of :done_at, message: 'Date is required'
  validate :vaccine_type_should_be_valid

  # validates :picture, file_size: { less_than: 512.kilobytes }
  mount_uploader :picture, PhotoUploader

  private

  def vaccine_type_should_be_valid
    errors.add(:vaccine_type_id, 'Vaccine type is invalid') unless pet.vaccine_type_ids.include?(vaccine_type_id)
  end
end
