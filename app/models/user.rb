class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :rememberable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :confirmable, :trackable, :omniauthable, :omniauth_providers => [:facebook, :google_oauth2]

  validates :email, uniqueness: { case_sensitive: false, message: 'Email address is already registered' },
                    format: { with: Devise.email_regexp },
                    length: { maximum: 50, message: 'Email address should contain not more than 50 symbols' },
                    presence: { message: 'Email adress is required' }

  validates_length_of :password, within: Devise.password_length,
                                 too_short: 'Password should contain at least 6 symbols',
                                 too_long: 'Password should contain not more than 32 symbols', allow_blank: true
  validates_confirmation_of :password, message: "Password confirmation doesn't match Password", if: :password_required?
  validates_presence_of :password, :password_confirmation, message: 'Password is required', if: :password_required?

  validates :last_name, format: { with: /\A[a-z\-A-Z\s,']+\z/ },
                        length: { within: 2..64,
                                  too_short: 'Last name should contain at least 2 symbols',
                                  too_long: 'Last name should contain not more than 64 symbols' },
                        presence: { message: 'Last name is required' }
  validates :first_name, format: { with: /\A[a-z\-A-Z\s,']+\z/, message: 'First name is invalid' },
                         length: { within: 2..64,
                                   too_short: 'First name should contain at least 2 symbols',
                                   too_long: 'First name should contain not more than 64 symbols' },
                         presence: { message: 'First name is required' }

  validates :phone_number, format: { with: /\A\+\d+\z/, message: 'Phone number is invalid' },
                           length: { within: 11..13,
                                     too_short: 'Phone number should contain at least 10 symbols',
                                     too_long: 'Phone number should contain not more than 12 symbols' },
                           allow_blank: true

  before_save :downcase_email, unless: ->(user) { user.email.blank? }

  attr_accessor :skip_password_validation

  has_many :sessions
  has_one :location, as: :place, inverse_of: :place
  accepts_nested_attributes_for :location, update_only: true

  def name
    first_name + ' ' + last_name
  end

  private

  def downcase_email
    self.email = email.downcase
  end

  def password_required?
    return false if skip_password_validation
    !persisted? || !password.nil? || !password_confirmation.nil?
  end
end
