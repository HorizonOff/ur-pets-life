module ServiceCentreConcern
  extend ActiveSupport::Concern
  include EmailCheckable

  included do
    # validates :email, uniqueness: { case_sensitive: false, message: 'Email address is already registered' },
    #                   format: { with: Devise.email_regexp, message: 'Email address is invalid' },
    #                   length: { maximum: 50, message: 'Email address should contain not more than 50 symbols' }
    # presence: { message: 'Email adress is required' }

    validates :name, presence: { message: 'Name is required' }

    # validates :mobile_number, uniqueness: { case_sensitive: false,
    #                                         message: 'This Mobile Number is already registered' },
    #                           format: { with: /\A\+\d+\z/, message: 'Mobile Number is invalid' },
    #                           length: { within: 11..13,
    #                                     too_short: 'Mobile number should contain at least 10 symbols',
    #                                     too_long: 'Mobile number should contain not more than 12 symbols' },
    #                           allow_blank: true

    validates :location, presence: { message: 'Location is required' }

    has_many :appointments, as: :bookable
    has_many :favorites, as: :favoritable, dependent: :destroy

    has_many :service_option_details, as: :serviceable, inverse_of: :serviceable
    has_many :service_options, through: :service_option_details
    accepts_nested_attributes_for :service_option_details, allow_destroy: true

    has_one :schedule, as: :schedulable, inverse_of: :schedulable
    has_one :location, as: :place, inverse_of: :place
    accepts_nested_attributes_for :location, update_only: true

    has_many :pictures, as: :picturable, inverse_of: :picturable, dependent: :destroy
    accepts_nested_attributes_for :pictures, allow_destroy: true
    validates :pictures, length: { maximum: 10, message: 'Should be maximum 10 pictures' }

    acts_as_paranoid

    mount_uploader :picture, PhotoUploader
    validates_presence_of :picture

    delegate :address, to: :location, allow_nil: true
    reverse_geocoded_by 'locations.latitude', 'locations.longitude'

    scope :alphabetical_order, -> { order(name: :asc) }

    after_save :check_admin
  end

  def build_relations
    if new_record?
      build_relations_for_new_record
    else
      build_service_option_details_with_blanks
    end
  end

  private

  def build_relations_for_new_record
    build_location unless location.present?
    build_schedule unless schedule.present?
    if service_option_details.present?
      build_service_option_details_with_blanks
    else
      build_default_service_option_details
    end
  end

  def build_service_option_details_with_blanks
    build_default_service_option_details(service_option_details.map(&:service_option_id))
  end

  def build_default_service_option_details(except_ids = [])
    options = ServiceOption.where.not(id: except_ids)
    options.map { |o| service_option_details.build(service_option: o) }
  end

  def check_admin
    return unless saved_changes.keys.include?('admin_id')
    appointments.each do |a|
      a.update_column(:admin_id, admin_id)
    end
  end
end
