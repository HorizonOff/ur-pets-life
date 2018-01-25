class ApplicationMailer < ActionMailer::Base
  default from: ENV['GMAIL_ADMIN']
  layout 'mailer'
end
