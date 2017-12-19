class Recipe < ApplicationRecord
  belongs_to :diagnosis
  validates :instruction, presence: { message: 'Instruction is required' }
end
