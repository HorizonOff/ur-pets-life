module ServiceCentreConcern
  extend ActiveSupport::Concern
  include EmailCheckable

  included do
    # validates :email, uniqueness: { case_sensitive: false, message: 'Email address is already registered' },
    #                   format: { with: Devise.email_regexp, message: 'Email address is invalid' },
    #                   length: { maximum: 50, message: 'Email address should contain not more than 50 symbols' }
    # presence: { message: 'Email adress is required' }

    validates :name, presence: { message: 'Name is required' }

    # validates :mobile_number, uniqueness: { case_sensitive: false,
    #                                         message: 'This Mobile Number is already registered' },
    #                           format: { with: /\A\+\d+\z/, message: 'Mobile Number is invalid' },
    #                           length: { within: 11..13,
    #                                     too_short: 'Mobile number should contain at least 10 symbols',
    #                                     too_long: 'Mobile number should contain not more than 12 symbols' },
    #                           allow_blank: true
    has_many :appointments, as: :bookable

    has_and_belongs_to_many :pet_types

    has_one :location, as: :place, inverse_of: :place
    accepts_nested_attributes_for :location, update_only: true

    mount_uploader :picture, PhotoUploader

    delegate :address, to: :location, allow_nil: true
    reverse_geocoded_by 'locations.latitude', 'locations.longitude'

    scope :alphabetical_order, -> { order(name: :asc) }
  end
end
