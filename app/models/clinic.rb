class Clinic < ApplicationRecord
  include ServiceCentreConcern
  belongs_to :admin, optional: true

  has_and_belongs_to_many :pet_types
  has_and_belongs_to_many :specializations
  has_many :vets, dependent: :destroy

  accepts_nested_attributes_for :schedule, update_only: true

  def admins_for_select
    if admin_id?
      Admin.for_clinic.pluck(:email, :id) << [admin.email, admin_id]
    else
      Admin.for_clinic.pluck(:email, :id)
    end
  end
end
