class ContactRequest < ApplicationRecord
  belongs_to :user, optional: true
  validates :email, presence: { message: 'Email is required' },
                    format: { with: Devise.email_regexp, message: 'Email address is invalid' },
                    length: { maximum: 50, message: 'Email address should contain not more than 50 symbols' }

  validates :user_name, presence: { message: 'User name is required' }, if: :landing?
  validates :subject, presence: { message: 'Subject is required' }, if: :mobile?
  validates :message, presence: { message: 'Message is required' }

  after_commit :notify_super_admin, on: :create

  def mobile?
    user_name.blank?
  end

  def landing?
    subject.blank?
  end

  private

  def notify_super_admin
    Admin.active.super.each do |sa|
      ContactRequestMailer.notify_super_admin(sa).deliver
    end
  end
end
