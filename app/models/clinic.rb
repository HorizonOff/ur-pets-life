class Clinic < ApplicationRecord
  validates :email, uniqueness: { case_sensitive: false, message: 'Email address is already registered' },
                    format: { with: Devise.email_regexp, message: 'Email address is invalid' },
                    length: { maximum: 50, message: 'Email address should contain not more than 50 symbols' },
                    presence: { message: 'Email adress is required' }

  validates :name, presence: { message: 'Name is required' }

  validates :mobile_number, uniqueness: { case_sensitive: false, message: 'This Mobile Number is already registered' },
                            format: { with: /\A\+\d+\z/, message: 'Mobile Number is invalid' },
                            length: { within: 11..13,
                                      too_short: 'Mobile number should contain at least 10 symbols',
                                      too_long: 'Mobile number should contain not more than 12 symbols' },
                            allow_blank: true

  before_save :downcase_email, unless: ->(clinic) { clinic.email.blank? }

  has_and_belongs_to_many :specializations
  has_and_belongs_to_many :pet_types
  has_one :location, as: :place, inverse_of: :place
  has_one :schedule, as: :schedulable, inverse_of: :schedulable

  accepts_nested_attributes_for :location, update_only: true
  accepts_nested_attributes_for :schedule, update_only: true

  mount_uploader :picture, PhotoUploader

  private

  def downcase_email
    self.email = email.downcase
  end
end
