class Vet < ApplicationRecord
  include EmailCheckable
  validates :email, format: { with: Devise.email_regexp, message: 'Email address is invalid' },
                    length: { maximum: 50, message: 'Email address should contain not more than 50 symbols' },
                    presence: { message: 'Email adress is required' }

  validates :name, presence: { message: 'Name is required' }

  validates :mobile_number, format: { with: /\A\+\d+\z/, message: 'Mobile Number is invalid' },
                            length: { within: 11..13,
                                      too_short: 'Mobile number should contain at least 10 symbols',
                                      too_long: 'Mobile number should contain not more than 12 symbols' },
                            allow_blank: true

  belongs_to :clinic, counter_cache: true

  has_and_belongs_to_many :specializations
  has_and_belongs_to_many :pet_types

  has_many :calendars, -> { order(start_at: :asc) }, dependent: :destroy
  has_many :appointments, dependent: :destroy
  has_many :qualifications, as: :skill, inverse_of: :skill
  has_many :favorites, as: :favoritable

  has_one :location, as: :place, inverse_of: :place
  has_one :schedule, as: :schedulable, inverse_of: :schedulable

  accepts_nested_attributes_for :qualifications, allow_destroy: true
  accepts_nested_attributes_for :location, update_only: true, allow_destroy: true

  mount_uploader :avatar, PhotoUploader

  delegate :address, to: :location, allow_nil: true
  reverse_geocoded_by 'locations.latitude', 'locations.longitude'

  before_validation :check_location

  private

  def check_location
    return location.destroy if !is_emergency? && location
    return unless use_clinic_location?
    location_attributes = clinic.location.attributes.except('id', 'place_type', 'place_id', 'created_at',
                                                            'updated_at', 'comment')
    build_location unless location
    location.assign_attributes(location_attributes)
  end
end
