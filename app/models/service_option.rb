class ServiceOption < ApplicationRecord
  validates :name, presence: { message: 'Name is required' }
end
