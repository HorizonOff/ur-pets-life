class ApplicationDecorator < Draper::Decorator
  include ActionView::Helpers::UrlHelper

  private

  def url_helpers
    Rails.application.routes.url_helpers
  end
end
