class ApplicationDecorator < Draper::Decorator
  include ActionView::Helpers::UrlHelper

  private

  def url_helpers
    Rails.application.routes.url_helpers
  end

  def app_icon
    host = ENV['ORIGINAL_URL'].present? ? 'https://' + ENV['ORIGINAL_URL'] : 'localhost:3000'
    host + '/images/AppIcon.png'
  end
end
