class Boarding < ApplicationRecord
  include ServiceCentreConcern
  belongs_to :admin, optional: true

  has_and_belongs_to_many :service_options
  has_many :service_types, as: :serviceable
  has_many :service_details, through: :service_types
  has_many :pet_types, through: :service_details

  accepts_nested_attributes_for :schedule, update_only: true

  def admins_for_select
    if admin_id?
      Admin.for_boarding.pluck(:email, :id) << [admin.email, admin_id]
    else
      Admin.for_boarding.pluck(:email, :id)
    end
  end
end
