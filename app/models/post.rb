class Post < ApplicationRecord
  belongs_to :author, -> { with_deleted }, polymorphic: true
  belongs_to :pet_type

  has_many :comments, as: :commentable, dependent: :destroy
  has_many :user_posts, dependent: :destroy

  acts_as_paranoid

  mount_uploader :image, PhotoUploader
  mount_uploader :video, VideoUploader

  validates :title, presence: { message: 'Title is required' }
  # validates :message, presence: { message: 'Message is required' }
  validate :content_should_be_valid, :ome_type_of_media

  delegate :name, to: :author, prefix: true
  delegate :avatar, to: :author, allow_nil: true

  after_commit :create_media_from_url, :create_user_post, on: :create

  scope :search, (lambda do |search|
    left_outer_joins(:comments)
    .where('posts.title ILIKe :search OR posts.message ILIKe :search OR comments.message ILIKe :search',
           search: "%#{search}%").distinct
  end)

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
    return if author_type == 'Admin' || author.user_posts.where(post_id: id).any?

    author.user_posts.create(post_id: id)
  end
end
