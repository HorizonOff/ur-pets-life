class SupportChat < ApplicationRecord
  enum status: { first_message: 0, active: 1, closed: 2 }

  belongs_to :user

  scope :without_closed, -> { where.not(status: 2) }
end
