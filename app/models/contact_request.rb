class ContactRequest < ApplicationRecord
  belongs_to :user
  validates :subject, :message, :user, presence: true
end
