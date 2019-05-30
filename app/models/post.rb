class Post < ApplicationRecord
  belongs_to :user, -> { with_deleted }
  belongs_to :pet_type

  has_many :comments, as: :commentable, dependent: :destroy
  has_many :user_posts, dependent: :destroy

  acts_as_paranoid

  validates :title, presence: { message: 'Title is required' }
  validates :message, presence: { message: 'Message is required' }

  delegate :name, to: :user, prefix: true
  delegate :avatar, to: :user, allow_nil: true

  after_commit :create_user_post, on: :create

  def update_counters(user_id)
    user_posts.find_by(user_id: user_id)&.update_column(:unread_post_comments_count, 0)
  end

  private

  def create_user_post
    return if user.user_posts.where(post_id: id).any?

    user.user_posts.create(post_id: id)
  end
end
