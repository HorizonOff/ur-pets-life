class BlockedTime < ApplicationRecord
  belongs_to :blockable, polymorphic: true
end
