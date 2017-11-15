class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :rememberable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :confirmable, :trackable, :validatable

  validates :email, uniqueness: { case_sensitive: false, message: 'This email is already registered' },
                    format: { with: Devise.email_regexp, message: 'Email address is invalid' }, length: { maximum: 50 },
                    presence: true

  before_save :downcase_email

  has_one :address
  accepts_nested_attributes_for :address, update_only: true

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
