class UsedPayCode < ApplicationRecord
  belongs_to :user
  belongs_to :order
  belongs_to :order
  belongs_to :code_user, class_name: 'User', foreign_key: :code_user_id

  has_many :notifications

  # after_commit :create_new_pay_code, :add_redeem_points, on: :create

  def create_new_pay_code
    return if code_user.pay_code.present?

    code_user.generate_pay_code
  end

  def add_redeem_points
    redeem_p = user.redeem_point
    redeem_p.update(totalearnedpoints: redeem_p.totalearnedpoints + 30,
                    net_worth: redeem_p.net_worth + 30)
  end
end
