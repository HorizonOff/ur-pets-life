class Session < ApplicationRecord
  # belongs_to :user

  belongs_to :client, polymorphic: true

  before_validation :check_device_type
  validates_uniqueness_of :device_id
  validates_presence_of :device_id, :device_type
  validates_inclusion_of :device_type, in: %w[ios android], message: 'Device type should be ios or android'

  before_save :set_token

  private

  def check_device_type
    self.device_type = device_type&.downcase
  end

  def set_token
    self.token = generate_token
  end

  def generate_token
    loop do
      token = SecureRandom.urlsafe_base64(16)
      break token unless Session.exists?(token: token)
    end
  end
end
