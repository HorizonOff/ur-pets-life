class Comment < ApplicationRecord
  belongs_to :user, -> { with_deleted }
  belongs_to :post, counter_cache: true

  validates :message, presence: { message: 'Message is required' }

  acts_as_paranoid

  delegate :name, to: :user, prefix: true
  delegate :avatar, to: :user, allow_nil: true
end
