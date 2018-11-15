module EmailCheckable
  extend ActiveSupport::Concern
  included do
    before_save :downcase_email, unless: ->(object) { object.email.blank? }
  end

  private

  def downcase_email
    self.email = email.downcase
  end
end
