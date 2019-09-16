class Item < ApplicationRecord
  mount_uploader :picture, PhotoUploader
  belongs_to :item_brand, optional: true
  has_many :wishlists
  has_many :shopping_cart_items, dependent: :destroy
  has_many :order_items
  has_many :item_reviews
  has_and_belongs_to_many :item_categories
  has_and_belongs_to_many :pet_types

  acts_as_paranoid

  scope :six_month_before_expiry_date, (lambda do
    where(expiry_at: Time.current..(Time.current + 6.month))
  end)

  scope :active, -> { where(is_active: true) }
  scope :sale, -> { where('items.discount > 0') }
  scope :first_month, (lambda do
    where('items.expiry_at BETWEEN (?) AND (?)',
          (Time.current + 1.month).beginning_of_month, (Time.current + 1.month).end_of_month)
  end)
  scope :second_month, (lambda do
    where('items.expiry_at BETWEEN (?) AND (?)',
          (Time.current + 2.month).beginning_of_month, (Time.current + 2.month).end_of_month)
  end)
  scope :third_month, (lambda do
    where('items.expiry_at BETWEEN (?) AND (?)',
          (Time.current + 3.month).beginning_of_month, (Time.current + 3.month).end_of_month)
  end)
  scope :fourth_month, (lambda do
    where('items.expiry_at BETWEEN (?) AND (?)',
          (Time.current + 4.month).beginning_of_month, (Time.current + 4.month).end_of_month)
  end)
  scope :discounted_items, (lambda do
    sale.where('items.expiry_at > ? OR items.expiry_at < ? OR items.expiry_at IS NULL',
               (Time.current + 4.month).end_of_month, Time.current.end_of_month)
  end)

  def smart_destroy
    any_item_relitions? ? really_destroy! : destroy
  end

  private

  def any_item_relitions?
    wishlists.blank? && order_items.blank? && item_reviews.blank? && item_brand.blank?
  end
end
