class AppVersion < ApplicationRecord
  validate :version_should_be_one, on: :create

  def version_should_be_one
    errors.add(:base, 'Version should be only one') if AppVersion.count == 1
  end
end
