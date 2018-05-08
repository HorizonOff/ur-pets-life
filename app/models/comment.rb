class Comment < ApplicationRecord
  belongs_to :writable,    -> { with_deleted }, polymorphic: true
  belongs_to :commentable, -> { with_deleted }, polymorphic: true, counter_cache: true

  validates :message, presence: { message: 'Message is required' }

  acts_as_paranoid
end
