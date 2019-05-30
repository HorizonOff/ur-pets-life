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

  after_commit :create_media_from_url, :create_user_post, on: :create

  def update_counters(user_id)
    user_posts.find_by(user_id: user_id)&.update_column(:unread_post_comments_count, 0)
  end

  private

  def create_media_from_url
    CreateImageWorker.perform_async(id, 'Post') if mobile_image_url.present?
    CreateVideoWorker.perform_async(id, 'Post') if mobile_video_url.present?
  end

  def content_should_be_valid
    errors.add(:base, 'Should be message or video or image') if image.blank? && video.blank? && message.blank?
  end

  def ome_type_of_media
    errors.add(:base, 'Only image or video in one post') if image.present? && video.present?
  end

  def create_user_post
    return if user.user_posts.where(post_id: id).any?

    user.user_posts.create(post_id: id)
  end
end
