class Post < ApplicationRecord
  belongs_to :user, -> { with_deleted }
  belongs_to :pet_type

  has_many :comments, dependent: :destroy

  acts_as_paranoid

  validates :title, presence: { message: 'Title is required' }
  validates :message, presence: { message: 'Message is required' }

  delegate :name, to: :user, prefix: true
  delegate :avatar, to: :user, allow_nil: true
end
