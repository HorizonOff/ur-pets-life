class AdminPolicy < ApplicationPolicy
  def not_him_self?
    user != record
  end
end
