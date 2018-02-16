class Session < ApplicationRecord
  belongs_to :user
  validates_uniqueness_of :device_id
  validates_presence_of :device_id, :device_type
  validates_inclusion_of :device_type, in: %w[ios android], message: 'Device type should be ios or android'

  before_save :set_token

  private

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
