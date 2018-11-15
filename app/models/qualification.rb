class Qualification < ApplicationRecord
  validates :diploma, presence: { message: 'Diploma is required' }
  validates :university, presence: { message: 'University is required' }

  belongs_to :skill, polymorphic: true
end
