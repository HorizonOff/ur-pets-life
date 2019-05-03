class Order < ApplicationRecord
  belongs_to :user
  belongs_to :location
  has_many :order_items
  has_many :notifications
  enum order_status_flag: { pending: "pending", confirmed: "confirmed", on_the_way: "on_the_way", delivered: "delivered", cancelled: "cancelled" }, _prefix: :order_status_flag

  acts_as_paranoid without_default_scope: true

  has_many :comments, as: :commentable, dependent: :destroy
  has_many :user_comments, -> { where(writable_type: 'User') }, as: :commentable, class_name: 'Comment'
  has_many :admin_comments, -> { where(writable_type: 'Admin') }, as: :commentable, class_name: 'Comment'
  has_one :last_comment, -> { order(id: :desc) }, as: :commentable, class_name: 'Comment'

  after_commit :update_user_spends

  def update_counters
    unread_comments_count_by_user = admin_comments.where(read_at: nil).count
    unread_comments_count_by_admin = user_comments.where(read_at: nil).count
    update_columns(unread_comments_count_by_user: unread_comments_count_by_user,
                   unread_comments_count_by_admin: unread_comments_count_by_admin)
  end

  scope :created_in_range, (lambda do |from_date, to_date|
    where('orders.created_at > ? AND orders.created_at < ?', from_date, to_date)
  end)

  private

  def update_user_spends
    user.update_spends
  end
end
