class Session < ApplicationRecord
  belongs_to :user
  validates_uniqueness_of :token, :device_id
  validates_presence_of :token, :device_id, :device_type, :push_token

  before_validate :generate_token

  private

  def generate_token
    loop do
      new_token = SecureRandom.urlsafe_base64(16)
      break unless Session.exists?(token: new_token)
    end
    self.token = new_token
  end
end
