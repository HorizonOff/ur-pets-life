class AdditionalService < ApplicationRecord
  validates :name, presence: { message: 'Name is required' }
  validates :location, presence: { message: 'Location is required' }

  has_many :favorites, as: :favoritable, dependent: :destroy

  has_one :location, as: :place, inverse_of: :place
  accepts_nested_attributes_for :location, update_only: true

  acts_as_paranoid

  mount_uploader :picture, PhotoUploader

  delegate :address, to: :location, allow_nil: true
  reverse_geocoded_by 'locations.latitude', 'locations.longitude'

  scope :alphabetical_order, -> { order(name: :asc) }
end
