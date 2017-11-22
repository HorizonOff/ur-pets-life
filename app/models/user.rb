class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :rememberable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :confirmable, :trackable, :validatable, :omniauthable, :omniauth_providers => [:facebook, :google_oauth2]

  validates :email, uniqueness: { case_sensitive: false, message: 'This email is already registered' },
                    format: { with: Devise.email_regexp }, length: { maximum: 50 }, unless: ->(user) { user.email.blank? }
  validates_presence_of :email, if: :email_required?
  validates_presence_of :first_name, :last_name

  before_save :downcase_email, unless: ->(user) { user.email.blank? }

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
    return false if facebook_id.present? && new_record?
    super
  end

  def downcase_email
    self.email = email.downcase
  end
end
