class Notification < ApplicationRecord
  belongs_to :admin, optional: true
  belongs_to :user, counter_cache: true
  belongs_to :appointment, optional: true
  belongs_to :pet, optional: true
  belongs_to :order, optional: true

  before_validation :set_user

  validates :message, presence: true

  after_commit :send_push, on: :create, unless: ->(obj) { obj.skip_push_sending? }

  delegate :name, to: :user

  def self.view
    # select { |n| n.viewed_at.blank? }.each do |n|
    #   n.update_column(:viewed_at, Time.current)
    # end
    where(viewed_at: nil).update_all(viewed_at: Time.current)
  end

  private

  def set_user
    self.user_id = appointment.user_id if appointment_id
  end

  def send_push
    return if Rails.env.test?
    PushSendingNotificationJob.perform_async(id)
  end
end
