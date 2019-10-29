class Admin < ApplicationRecord
  enum role: { simple_admin: 0, super_admin: 1, employee: 2, cataloger: 3, msh_admin: 4, driver: 5 }
  include EmailCheckable
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :registerable,, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable,
         validate_on_invite: true

  mount_uploader :avatar, PhotoUploader

  has_one :clinic, dependent: :nullify
  has_one :day_care_centre, dependent: :nullify
  has_one :grooming_centre, dependent: :nullify
  has_one :boarding, dependent: :nullify

  has_many :appointments, dependent: :nullify
  has_many :notifications
  has_many :orders, class_name: 'Order', foreign_key: 'driver_id'

  has_many :comments, as: :writable, dependent: :destroy
  has_many :posts, as: :author, class_name: 'Post', dependent: :destroy
  has_many :sessions, as: :client, class_name: 'Session', dependent: :destroy

  has_many :vets, through: :clinic

  acts_as_paranoid

  validates_uniqueness_of :email, conditions: -> { with_deleted }

  after_update :send_location_to_channel

  scope :simple, -> { where(is_super_admin: false) }
  scope :super, -> { where(is_super_admin: true) }
  scope :active, -> { where.not(invitation_accepted_at: nil).or(where(invitation_sent_at: nil)) }

  scope :for_clinic, -> { simple.left_joins(:clinic).having('count(clinics.id) = 0').group('admins.id') }

  scope :for_day_care_centre, (lambda do
    simple.left_joins(:day_care_centre).having('count(day_care_centres.id) = 0').group('admins.id')
  end)

  scope :for_grooming_centre, (lambda do
    simple.left_joins(:grooming_centre).having('count(grooming_centres.id) = 0').group('admins.id')
  end)

  scope :for_boarding, (lambda do
    simple.left_joins(:boarding).having('count(boardings.id) = 0').group('admins.id')
  end)

  def update_counters
    self.unread_commented_appointments_count = appointments.where('unread_comments_count_by_admin > 0').count
    save
  end

  def update_counters_for_order
    self.unread_commented_appointments_count = orders.where('unread_comments_count_by_admin > 0').count
    save
  end

  def confirmed?
    true
  end

  private

  def send_location_to_channel
    return unless saved_change_to_attribute?(lat) || saved_change_to_attribute?(lng)

    return if orders.order_status_flag_on_the_way.count.zero?

    redis_key = "admin_location:#{id}"
    all_ids = JSON.parse($redis.get(redis_key) || '[]')
    return if all_ids.blank?

    ActionCable.server.broadcast("driver-#{id}:location", lat: lat, lng: lng)
  end
end
