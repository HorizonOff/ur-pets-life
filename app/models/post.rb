class Post < ApplicationRecord
  belongs_to :user
  belongs_to :pet_type

  has_many :comments

  validates :title, presence: { message: 'Title is required' }
  validates :message, presence: { message: 'Message is required' }

  delegate :name, to: :user, prefix: true
  delegate :avatar, to: :user, allow_nil: true
end
