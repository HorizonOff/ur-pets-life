class Admin < ApplicationRecord
  include EmailCheckable
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :registerable,, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable

  mount_uploader :avatar, PhotoUploader
end
