class Ad < ApplicationRecord
  mount_uploader :image, AdImageUploader

  after_commit :inactive, on: :create

  def self.active
    find_by(is_active: true)
  end

  def self.make_inactive
    ad = find_by(is_active: true)
    return if ad.blank?

    ad.is_active = false
    ad.save
  end

  private

  def inactive
    return unless is_active?

    ad = Ad.where.not(id: id).find_by(is_active: true)
    return if ad.blank?

    ad.is_active = false
    ad.save
  end
end
