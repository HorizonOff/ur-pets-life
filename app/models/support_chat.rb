class SupportChat < ApplicationRecord
  enum status: { new: 0, active: 1, closed: 2 }

  belongs_to :user
end
