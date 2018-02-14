class User < ApplicationRecord
  include EmailCheckable
  GENDER_OPTIONS = %i[male female].freeze
  enum gender: GENDER_OPTIONS

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

  validate :gender_should_be_valid

  attr_accessor :skip_password_validation

  acts_as_paranoid

  has_one :location, as: :place, inverse_of: :place

  has_many :favorites, -> { order(created_at: :asc) }, dependent: :destroy
  has_many :sessions, dependent: :destroy
  has_many :pets, dependent: :destroy
  has_one :pet_avatar, -> { order(id: :asc).limit(1) }, class_name: 'Pet'
  has_many :appointments
  has_many :posts
  has_many :comments

  accepts_nested_attributes_for :location, update_only: true, reject_if: :all_blank

  delegate :address, to: :location, allow_nil: true
  delegate :avatar, to: :pet_avatar, allow_nil: true

  before_validation :check_location

  def birthday=(value)
    value = Time.zone.at(value.to_i)
    super
  end

  def name
    first_name + ' ' + last_name
  end

  def gender=(value)
    super value if value.nil?
    value = value.to_i if value.in?(%w[0 1])
    super value
    @gender_backup = nil
  rescue ArgumentError => exception
    error_message = 'is not a valid gender'
    raise unless exception.message.include?(error_message)
    @gender_backup = value
    self[:gender] = nil
  end

  private

  def check_location
    location.really_destroy! if location.present? && address.blank?
  end

  def password_required?
    return false if skip_password_validation
    !persisted? || !password.nil? || !password_confirmation.nil?
  end

  def gender_should_be_valid
    return unless @gender_backup
    self.gender ||= @gender_backup
    error_message = 'Gender is invalid'
    errors.add(:gender, error_message)
  end
end
