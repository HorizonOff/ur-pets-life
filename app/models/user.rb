class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :rememberable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :confirmable, :trackable, :validatable, :omniauthable, :omniauth_providers => [:facebook, :google_oauth2]

  validates :email, uniqueness: { case_sensitive: false, message: 'This email is already registered' },
                    format: { with: Devise.email_regexp }, length: { maximum: 50 },
                    presence: true

  before_save :downcase_email

  has_many :sessions
  has_one :location, as: :place, inverse_of: :place
  accepts_nested_attributes_for :location, update_only: true

  def name
    first_name + ' ' + last_name
  end

  private

  def password_required?
    return false if is_social?
    super
  end

  def email_required?
    facebook_id.nil?
  end

  def downcase_email
    self.email = email.downcase
  end
end
