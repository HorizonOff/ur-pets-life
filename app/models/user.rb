class User < ApplicationRecord
  include EmailCheckable
  # Include default devise modules. Others available are:
  # :rememberable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :confirmable, :trackable, :omniauthable, omniauth_providers: %i[facebook google_oauth2]

  validates :email, uniqueness: { case_sensitive: false, message: 'Email address is already registered' },
                    format: { with: Devise.email_regexp, message: 'Email address is invalid' },
                    length: { maximum: 50, message: 'Email address should contain not more than 50 symbols' },
                    presence: { message: 'Email adress is required' }

  validates_length_of :password, within: Devise.password_length,
                                 too_short: 'Password should contain at least 6 symbols',
                                 too_long: 'Password should contain not more than 32 symbols', allow_blank: true
  validates_confirmation_of :password, message: "Passwords don't match", if: :password_required?
  validates_presence_of :password, :password_confirmation, message: 'Password is required', if: :password_required?

  validates :last_name, format: { with: /\A[a-z\-A-Z\s,']+\z/, message: 'Last name is invalid' },
                        length: { within: 2..64,
                                  too_short: 'Last name should contain at least 2 symbols',
                                  too_long: 'Last name should contain not more than 64 symbols' },
                        presence: { message: 'Last name is required' }
  validates :first_name, format: { with: /\A[a-z\-A-Z\s,']+\z/, message: 'First name is invalid' },
                         length: { within: 2..64,
                                   too_short: 'First name should contain at least 2 symbols',
                                   too_long: 'First name should contain not more than 64 symbols' },
                         presence: { message: 'First name is required' }

  validates :mobile_number, uniqueness: { case_sensitive: false, message: 'This Mobile Number is already registered' },
                            format: { with: /\A\+\d+\z/, message: 'Mobile Number is invalid' },
                            length: { within: 11..13,
                                      too_short: 'Mobile number should contain at least 10 symbols',
                                      too_long: 'Mobile number should contain not more than 12 symbols' },
                            allow_blank: true

  validates :facebook_id, :google_id, uniqueness: true, allow_blank: true

  attr_accessor :skip_password_validation

  has_many :sessions
  has_many :pets
  has_many :appointments
  has_one :location, as: :place, inverse_of: :place

  accepts_nested_attributes_for :location, update_only: true

  delegate :address, to: :location, allow_nil: true

  def name
    first_name + ' ' + last_name
  end

  private

  def password_required?
    return false if skip_password_validation
    !persisted? || !password.nil? || !password_confirmation.nil?
  end
end
