class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :rememberable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :confirmable, :trackable, :validatable, :omniauthable,
         omniauth_providers: %i[facebook google_oauth2]

  validates :email, uniqueness: { case_sensitive: false, message: 'is already registered' },
                    format: { with: Devise.email_regexp }, length: { maximum: 50 },
                    presence: true
  validates :first_name, :last_name, format: { with: /\A[a-z\-A-Z\s,']+\z/ }, length: { minimum: 2, maximum: 64 },
                                     presence: true
  validates :phone_number, format: { with: /\A\+\d+\z/ }, length: { minimum: 11, maximum: 13 }, allow_blank: true

  before_save :downcase_email, unless: ->(user) { user.email.blank? }

  has_many :sessions
  has_many :pets
  has_one :location, as: :place, inverse_of: :place
  accepts_nested_attributes_for :location, update_only: true

  def name
    first_name + ' ' + last_name
  end

  private

  def downcase_email
    self.email = email.downcase
  end
end
