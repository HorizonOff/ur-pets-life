class Admin < ApplicationRecord
  include EmailCheckable
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :registerable,, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable

  mount_uploader :avatar, PhotoUploader

  has_one :clinic, dependent: :nullify
  has_one :day_care_centre, dependent: :nullify
  has_one :grooming_centre, dependent: :nullify
  has_one :boarding, dependent: :nullify

  has_many :appointments, dependent: :nullify
  has_many :notifications, dependent: :nullify

  acts_as_paranoid

  scope :simple, -> { where(is_super_admin: false) }
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
end
