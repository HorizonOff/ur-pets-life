class Boarding < ApplicationRecord
  include ServiceCentreConcern
  belongs_to :admin, optional: true

  has_many :service_option_details, -> { order(service_option_id: :asc) }, as: :service_optionable,
                                                                           inverse_of: :service_optionable
  has_many :service_options, through: :service_option_details

  has_many :service_types, as: :serviceable
  has_many :service_details, through: :service_types
  has_many :pet_types, through: :service_details

  has_many :pictures, as: :picturable, inverse_of: :picturable, dependent: :destroy
  accepts_nested_attributes_for :pictures, allow_destroy: true
  validates :pictures, length: { maximum: 6, message: 'Should be maximum 6 pictures' }

  accepts_nested_attributes_for :schedule, update_only: true
  accepts_nested_attributes_for :service_option_details, allow_destroy: true

  def admins_for_select
    if admin_id?
      Admin.for_boarding.pluck(:email, :id) << [admin.email, admin_id]
    else
      Admin.for_boarding.pluck(:email, :id)
    end
  end

  attr_accessor :attachments
end
