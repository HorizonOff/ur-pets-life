class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :post, counter_cache: true

  validates :message, presence: { message: 'Message is required' }

  delegate :name, to: :user, prefix: true
  delegate :avatar, to: :user, allow_nil: true
end
