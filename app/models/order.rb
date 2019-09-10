class Order < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :location
  has_one :used_pay_code

  has_many :order_items, dependent: :destroy
  has_many :notifications
  accepts_nested_attributes_for :order_items, allow_destroy: true
  accepts_nested_attributes_for :location
  enum order_status_flag: { pending: "pending", confirmed: "confirmed", on_the_way: "on_the_way",
                            delivered: "delivered", delivered_by_card: "delivered_by_card",
                            delivered_by_cash: "delivered_by_cash",
                            cancelled: "cancelled" }, _prefix: :order_status_flag

  has_many :comments, as: :commentable, dependent: :destroy
  has_many :user_comments, -> { where(writable_type: 'User') }, as: :commentable, class_name: 'Comment'
  has_many :admin_comments, -> { where(writable_type: 'Admin') }, as: :commentable, class_name: 'Comment'
  has_one :last_comment, -> { order(id: :desc) }, as: :commentable, class_name: 'Comment'

  after_commit :set_delivery_at, on: :update
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

  scope :deliver_or_created_in_range, (lambda do |from_date, to_date|
    where('(orders.delivery_at IS NOT NULL AND orders.delivery_at > :from_date AND orders.delivery_at < :to_date) OR
          (orders.delivery_at IS NULL AND orders.created_at > :from_date AND orders.created_at < :to_date)',
          from_date: from_date, to_date: to_date)
  end)

  scope :yesterday, (lambda do
    where('orders.created_at > ? AND orders.created_at < ?',
          DateTime.yesterday.beginning_of_day, DateTime.yesterday.end_of_day)
  end)

  scope :visible, -> { where(is_pre_recurring: false) }

  private

  def set_delivery_at
    return unless saved_change_to_attribute?(:order_status_flag, to: 'delivered') ||
                  saved_change_to_attribute?(:order_status_flag, to: 'delivered_by_card') ||
                  saved_change_to_attribute?(:order_status_flag, to: 'delivered_by_cash')

    update_column(:delivery_at, Time.current)
  end

  def update_user_spends
    return if user.blank?

    user.update_spends
  end
end
