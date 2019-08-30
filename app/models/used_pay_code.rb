class UsedPayCode < ApplicationRecord
  belongs_to :user
  belongs_to :order
  belongs_to :code_user, class_name: 'User', foreign_key: :code_user_id
end
